module ApplicationHelper
  def flash_messages
    messages = ''
    %i[notice info warning alert].each do |type|
      messages += formated_flash(type, flash[type]) if flash[type]
    end

    messages.html_safe
  end

  private

  def formated_flash(type, messages)
    if type == :notice
      "<div class=\"alert alert-success\" role='alert'>#{splited_messages(messages)}</div>"
    elsif type == :alert
      "<div class=\"alert alert-danger\" role='alert'>#{splited_messages(messages)}</div>"
    else
      "<div class=\"alert alert-#{type}\" role='alert'>#{splited_messages(messages)}</div>"
    end
  end

  def splited_messages(messages)
    messages.chomp.gsub("\n", '<br>')
  end
end
