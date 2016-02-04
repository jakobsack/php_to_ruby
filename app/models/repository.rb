class Repository < ActiveRecord::Base
  has_many :tags
  has_many :branches

  after_create :update_repository
  before_save :update_pulled_at

  # Fetches the repository
  def fetch
    update_repository
    update_pulled_at
    save!
  end

  def diff(from, to)
    Dir.chdir(path) do
      Diff.parse(`git diff --no-color -U10 #{from.name} #{to.name}`)
    end
  end

  protected

  # updates pulled_at row
  def update_pulled_at
    self.pulled_at = Time.now
  end

  # Fetches the repository
  def update_repository
    if File.exist?(path)
      Dir.chdir(path) do
        system('git', 'fetch')
      end
    else
      Dir.chdir(root) do
        system('git', 'clone', '--bare', '--local', url, id.to_s)
      end
    end

    update_tags
    update_branches

    true
  end

  # Update tags database
  def update_tags
    known_tags = tags.to_a
    Dir.chdir(path) do
      `git tag --no-column`.lines.each do |name|
        name = name.chomp

        tag = known_tags.delete_if { |t| t.name == name }.first
        tags.create(name: name) unless tag
      end
    end

    # Delete tags that do not exist anymore
    known_tags.each { |t| t.delete }
  end

  # Update branch database
  def update_branches
    known_branches = branches.to_a
    Dir.chdir(path) do
      `git branch --list --no-column --no-color`.lines.each do |name|
        name = branch_name(name)

        branch = known_branches.delete_if { |b| b.name == name }.first
        branches.create(name: name) unless branch
      end
    end

    # Delete tags that do not exist anymore
    known_branches.each { |b| b.delete }
  end

  # get branch name
  def branch_name(name)
    name.chomp.split(' ').last
  end

  # Internal path to repository
  def path
    File.join(root, id.to_s)
  end

  # Root of our repositories
  def root
    File.join(Rails.root, 'repositories')
  end
end
