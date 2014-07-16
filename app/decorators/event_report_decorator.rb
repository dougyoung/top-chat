class EventReportDecorator < ApplicationDecorator
  def display
    elements = []
    elements << timestamp
    elements << object.events.map do |event|
      h.content_tag :dd, humanize(:report, event[:action], options(event))
    end

    elements.join.html_safe
  end

  def timestamp
    timestamp = super(:hour, Time.parse("#{object.hour}:00"))
    h.content_tag :dt, "#{timestamp}:"
  end

  private

  def options(event)
    {
      count: event[:count],
      receivers: event[:receivers],
      senders: event[:senders],
      scope: [:event, :report]
    }
  end
end
