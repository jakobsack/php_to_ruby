module RepositoriesHelper
  def port(line)
    Porter.port(line)
  end

  def diff_title(file)
    if file[0] == file[1]
      file[1]
    else
      (file[0] || '/dev/null') + ' -> ' + (file[1] || '/dev/null')
    end
  end

  def diff_port(line)
    Porter.port(line)
  end

  def diff_code(line)
    line = ' ' if line.blank?
    line = CGI.escapeHTML(line)
    raw line.gsub(' ', '&nbsp;')
  end

  def diff_php_file?(file)
    ( file[0] && file[0] =~ /\.php$/ ) ||
        (file[1] && file[1] =~ /\.php$/ )
  end
end
