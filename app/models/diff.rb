class Diff
  # parses the diff
  def self.parse(diff)
    new(diff).parse
  end

  def initialize(diff)
    diff = diff.lines unless diff.is_a?(Array)
    @diff = diff.map { |l| l.gsub(/[\r\n]/, '') }
    @parsed = nil
  end

  def parse
    @parsed ||= parse_diff
  end

  protected

  def parse_diff
    @parsed = {}
    @file = [nil, nil]
    while @diff.size > 0
      line = @diff.shift

      if line =~ %r{^\-\-\- a/(.+)$}
        # old file name
        @file[0] = $1
      elsif line =~ %r{^\+\+\+ b/(.+)$}
        # new file name
        @file[1] = $1
      elsif line =~ /^diff/ ||
          line =~ /^index/ ||
          line =~ /^\-\-\-/ ||
          line =~ /^\+\+\+/ ||
          line =~ /^\s+$/
        # skip known lines
      else
        @diff.unshift(line)
        @parsed[@file] = []
        parse_file
        @file = [nil, nil]
      end
    end
    @parsed
  end

  def parse_file
    while @diff.size > 0
      line = @diff.shift

      if line =~ /^diff/
        @diff.unshift(line)
        return
      elsif line =~ /^@@/
        @parsed[@file] << {
          type: :locator,
          line: line
        }
      elsif line[0] == '+'
        @parsed[@file] << {
          type: :added,
          line: line[1..-1] || ''
        }
      elsif line[0] == '-'
        @parsed[@file] << {
          type: :removed,
          line: line[1..-1] || ''
        }
      else
        @parsed[@file] << {
          type: :equal,
          line: line[1..-1] || ''
        }
      end
    end
  end
end
