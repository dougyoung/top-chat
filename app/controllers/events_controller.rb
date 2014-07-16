class EventsController < ApplicationController
  include Dateable

  def index
    @start_date = datetime_or_default params[:start_date]
    @interval = params[:interval] || :realtime

    @errors = []
    if @interval.to_sym == :realtime
      @events = Event.for(@start_date).decorate
    else
      if @interval.to_sym == :hour
        @events = Event.report(@start_date).map do |event|
          EventReport.new(event).decorate
        end
      else
        @errors << I18n.t('errors.invalid', key: :interval, value: @interval)
      end
    end
  end
end
