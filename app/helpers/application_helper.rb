module ApplicationHelper
  def flash_messages
    code = ''
    flash.to_hash.merge( @flash_messages || {}).each do |type, text|
      code += '<div class="container alert alert-' +
          bootstrap_type(type) +
          ' flash flash-' +
          type +
          '" role="alert"><a class="close" data-dismiss="alert">&times;</a>' +
          text +
          '</div>'
    end
    raw code
  end

  def bootstrap_type type
    case type
    when 'notice'
      'info'
    when 'alert'
      'warning'
    else
      type
    end
  end
end
