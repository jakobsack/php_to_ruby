class Porter
  def self.port(line)
    newline = line.chomp

    return '' if newline =~ /^\s*\/\*\*?\s*$/
    return '' if newline =~ /^\s*\*\/\s*$/

    # -> syntax
    newline.gsub!(/\$this->([a-z][a-zA-Z0-9_]*)$/) {|m| "@#{$1.underscore}" }
    newline.gsub!(/\$this->([a-z][a-zA-Z0-9_]*)([^a-zA-Z0-9_\(])/) {|m| "@#{$1.underscore}#{$2}" }

    newline.gsub!(/->([a-z][a-zA-Z0-9_]*)/) {|m| ".#{$1.underscore}" }
    newline.gsub!('$this', 'self')
    newline.gsub!(/\$([a-z][a-zA-Z0-9_]*)/) {|m| $1.underscore }
    newline.gsub!(/^(\s*)\*/) {|m| "#{$1}#" }
    newline.gsub!(/^(\s*)\/\//) {|m| "#{$1}#" }

    newline.gsub!(/new ([a-zA-Z0-9_\\]+)\(/) { |m| "#{$1}.new(" }
    newline.gsub!(/(\s[a-z][a-zA-Z0-9_]*)\(/) {|m| "#{$1.underscore}(" }
    newline.gsub!('()', '')
    newline.gsub!(/;\s*$/, '')
    newline.gsub!('[] =', ' <<')
    newline.gsub!('!==', '!=')
    newline.gsub!('===', '==')
    newline.gsub!('elseif', 'elsif')
    newline.gsub!('} else {', 'else')

    newline.gsub!(/^(\s*)class(.*)\{$/) {|m| "#{$1}class#{$2}" }
    newline.gsub!(/^(\s*)(?:public |)function(.*)\{$/) {|m| "#{$1}def#{$2}" }

    newline.gsub!(/^(\s*)\}$/) {|m| "#{$1}end" }

    newline.gsub!(/^#/, '#')

    # foreach
    newline.gsub!(/foreach\s*\(\s*(.*)\s+as\s+([a-z][a-zA-Z0-9_]*)\s*=>\s*([a-z][a-zA-Z0-9_]*)\s*\)\s*\{/) {|m| "#{$1}.each do |#{$2}, #{$3}|" }
    newline.gsub!(/foreach\s*\(\s*(.*)\s+as\s+([a-z][a-zA-Z0-9_]*)\s*\)\s*\{/) {|m| "#{$1}.each do |#{$2}|" }

    # Testing
    newline.gsub!('self.assert_equals', 'assert_equal')
    newline.gsub!('self.assert_nil', 'assert_nil')
    newline.gsub!('self.assert_true', 'assert')
    newline.gsub!('self.assert_false', 'refute')
    newline.gsub!('self.assert_array_has_key', 'assert_has_key')
    newline.gsub!('self.assert_instance_of', 'assert_kind_of')
    newline.gsub!('extends \\PHPUnit_Framework_TestCase', '< Minitest::Test')

    newline
  end
end
