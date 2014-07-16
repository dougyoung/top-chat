class EventDecorator < ApplicationDecorator
  def display
    h.content_tag :dd, "#{timestamp}: #{humanize(:action, object.action, options)}"
  end

  private

  def options
    {
      content: object.content,
      receiver: object.receiver,
      sender: object.sender
    }
  end
end
