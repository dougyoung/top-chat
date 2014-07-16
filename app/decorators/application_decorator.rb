class ApplicationDecorator < Draper::Decorator
  protected

  def humanize(attribute, value, options={})
    options.reverse_merge!({ default:  value })
    options.reverse_merge!({ scope: [model_name, attribute] }) if model_name

    I18n.t value, options
  end

  def timestamp(format = :hour_minute, value = object.created_at)
    I18n.l value, format: format
  end

  private

  def model_name
    @model_name ||= object.model_name.to_s.downcase if object.respond_to? :model_name
  end
end
