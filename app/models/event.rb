class Event
  include Reportable
  include Mongoid::Document
  include Mongoid::Timestamps

  ActionsWithContent = %w(comment)
  ActionsWithReceiver = %w(high-five-another-user)
  Actions = %w(enter-the-room leave-the-room) \
                + ActionsWithContent + ActionsWithReceiver

  field :content, type: String
  field :action, type: String
  field :receiver, type: String # User
  field :sender, type: String # User

  EVENT_LIMIT = 1000
  scope :for, ->(date_start = Date.today.to_datetime, date_end = date_start + 1.day) {
    where(:created_at.gte => date_start, :created_at.lt => date_end)
      .limit(EVENT_LIMIT)
      .order_by(created_at: 1)
  }

  validates_presence_of :content, if: lambda { ActionsWithContent.include?(:action) }
  validates_presence_of :action, :sender
  validates_presence_of :receiver, if: lambda { ActionsWithReceiver.include?(:action) }
  validates_inclusion_of :action, in: Actions
end
