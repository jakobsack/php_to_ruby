class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :update, :destroy, :fetch, :diff]

  # GET /repositories
  # GET /repositories.json
  def index
    @repositories = Repository.all
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
  end

  # POST /repositories
  # POST /repositories.json
  def create
    @repository = Repository.new(create_repository_params)

    respond_to do |format|
      if @repository.save
        format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
        format.json { render :show, status: :created, location: @repository }
      else
        format.html { render :new }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repositories/1
  # PATCH/PUT /repositories/1.json
  def update
    respond_to do |format|
      if @repository.update(update_repository_params)
        format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
        format.json { render :show, status: :ok, location: @repository }
      else
        format.html { render :edit }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    @repository.destroy
    respond_to do |format|
      format.html { redirect_to repositories_url, notice: 'Repository was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /repositories/1/fetch
  # POST /repositories/1/fetch.json
  def fetch
    @repository.fetch
    respond_to do |format|
      format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
      format.json { head :no_content }
    end
  end

  # GET /repositories/1/diff
  def diff
    @from = source(params[:from])
    @to = source(params[:to])

    redirect_to @repository, alert: 'Could not compare given versions.' unless @from && @to

    @diff = @repository.diff(@from, @to)
  end

  private
    # Gets the correct source object (or nil)
    def source(name)
      if name =~ /^tag(\d+)$/
        @repository.tags.find($1)
      elsif name =~ /^branch(\d+)$/
        @repository.branches.find($1)
      else
        nil
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_repository_params
      params.require(:repository).permit(:name, :url)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_repository_params
      params.require(:repository).permit(:name)
    end
end
