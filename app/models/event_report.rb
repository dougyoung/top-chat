class EventReport
  include Draper::Decoratable

  attr_reader :hour, :events

  def initialize(attrs={})
    @hour = attrs['_id']
    @events = attrs['events']
  end
end
