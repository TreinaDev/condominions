module ApplicationHelper
  def flash_messages
    messages = ''
    %i[notice info warning alert].each do |type|
      messages += formatted_flash(type, flash[type]) if flash[type]
    end

    sanitize messages
  end

  private

  def formatted_flash(type, messages)
    if type == :notice
      "<div class=\"alert alert-success\" role='alert'>#{split_messages(messages)}</div>"
    elsif type == :alert
      "<div class=\"alert alert-danger\" role='alert'>#{split_messages(messages)}</div>"
    else
      "<div class=\"alert alert-#{type}\" role='alert'>#{split_messages(messages)}</div>"
    end
  end

  def split_messages(messages)
    messages.chomp.gsub("\n", '<br>')
  end
end
