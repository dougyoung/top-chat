module Dateable
  extend ActiveSupport::Concern

  included do
    rescue_from ArgumentError, with: Date.today.to_datetime
  end

  # Takes a hash as:
  #   { year: y, month: m, day: d, hour: h, minute: m, second: s }
  # All fields optional, but must be in correct order without skipping values
  # Returns equivalent DateTime object
  # Defaults to today's DateTime on error
  def datetime_or_default(params)
    return Date.today.to_datetime if params.blank?
    return Date.today.to_datetime if params.values.any? { |v| v.blank? }

    DateTime.new(*params.values.map(&:to_i))
  end
end
