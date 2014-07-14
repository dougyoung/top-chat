FactoryGirl.define do
  factory :event do
    sender 'sender'
    enter_the_room

    trait :enter_the_room do
      action 'enter-the-room'
    end

    trait :leave_the_room do
      action 'leave-the-room'
    end
  end
end
