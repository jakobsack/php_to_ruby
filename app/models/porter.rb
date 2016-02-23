class Porter
  def self.port(line)
    newline = line.chomp

    return '' if newline =~ /^\s*\/\*\*?\s*$/
    return '' if newline =~ /^\s*\*\/\s*$/

    # instance variables
    newline.gsub!(/\$this->([a-z][a-zA-Z0-9_]*)$/) {|m| "@#{$1.underscore}" }
    newline.gsub!(/\$this->([a-z][a-zA-Z0-9_]*)([^a-zA-Z0-9_\(])/) {|m| "@#{$1.underscore}#{$2}" }

    # method names
    newline.gsub!(/->([a-z][a-zA-Z0-9_]*)\(/) {|m| ".#{$1.underscore}(" }
    newline.gsub!(/::([a-z][a-zA-Z0-9_]*)\(/) {|m| ".#{$1.underscore}(" }
    newline.gsub!(/(\s[a-z][a-zA-Z0-9_]*)\(/) {|m| "#{$1.underscore}(" }

    # variables
    newline.gsub!('$this', 'self')
    newline.gsub!(/\$([a-z][a-zA-Z0-9_]*)/) {|m| $1.underscore }

    # comments
    newline.gsub!(/^(\s*)\*/) {|m| "#{$1}#" }
    newline.gsub!(/^(\s*)\/\//) {|m| "#{$1}#" }

    # object initialization
    newline.gsub!(/new ([a-zA-Z0-9_\\]+)\(/) { |m| "#{$1}.new(" }
    newline.gsub!(/;\s*$/, '')
    newline.gsub!('__construct', 'initialize')
    newline.gsub!('()', '')

    # Replace common patterns
    newline.gsub!('[] =', ' <<')
    newline.gsub!('!==', '!=')
    newline.gsub!('===', '==')
    newline.gsub!(/^(\s*)\}$/) {|m| "#{$1}end" }

    # if/elseif/else
    newline.gsub!('elseif', 'elsif')
    newline.gsub!(/\}\s*elsif\s*\((.+)\)\s*\{/) { |m| "elsif #{$1}" }
    newline.gsub!(/if\s*\((.+)\)\s*\{/) { |m| "if #{$1}" }
    newline.gsub!('} else {', 'else')

    # Class and method definition
    newline.gsub!(/^(\s*)class(.*)\{$/) {|m| "#{$1}class#{$2}" }
    newline.gsub!(/^(\s*)(?:public |)function(.*)\{$/) {|m| "#{$1}def#{$2}" }

    # Eh?
    newline.gsub!(/^#/, '#')

    # instanceof
    newline.gsub!(/ instanceof ([\d\w_\\]+)/) { ".is_a?(#{$1})" }

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
