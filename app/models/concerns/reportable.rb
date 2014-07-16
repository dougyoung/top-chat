module Reportable
  extend ActiveSupport::Concern

  module ClassMethods
    def report(datetime_begin = Date.today.to_datetime, datetime_end = datetime_begin + 1.day)
      # Match all records between the given dates
      match = {
        '$match' => {
          created_at: { '$gte' => datetime_begin, '$lt' => datetime_end }
        }
      }

      # Group by action and hour
      # Count actions and collect unique participants
      group = {
        '$group' => {
          _id: {
            action: '$action',
            hour: { '$hour' => '$created_at' }
          },
          count: { '$sum' => 1 },
          receivers: { '$addToSet' => '$receiver' },
          senders: { '$addToSet' => '$sender' }
        }
      }

      # Re-group events by hour, counting participants per action
      group_by_hour = {
        '$group' => {
          _id: '$_id.hour',
          events: {
            '$push' => {
              action: '$_id.action',
              count: '$count',
              receivers: { '$size' => '$receivers' },
              senders: { '$size' => '$senders' }
            }
          }
        }
      }

      sort_chronologically = { '$sort' => { _id: 1 } }

      self.collection.aggregate(match, group, group_by_hour, sort_chronologically)
    end
  end
end
