# Today
today = Date.today.to_s
# 5pm
Event.collection.insert(created_at: DateTime.parse(today + ' 5:00pm'), action: 'enter-the-room', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 5:05pm'), action: 'enter-the-room', sender: 'Kate')
Event.collection.insert(created_at: DateTime.parse(today + ' 5:15pm'), action: 'comment', content: 'Hey, Kate - high five?', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 5:17pm'), action: 'high-five-another-user', sender: 'Kate', receiver: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 5:18pm'), action: 'leave-the-room', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 5:20pm'), action: 'comment', content: 'Oh, typical', sender: 'Kate')
Event.collection.insert(created_at: DateTime.parse(today + ' 5:21pm'), action: 'leave-the-room', sender: 'Kate')
# 6pm
Event.collection.insert(created_at: DateTime.parse(today + ' 6:00pm'), action: 'enter-the-room', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:01pm'), action: 'enter-the-room', sender: 'Kate')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:02pm'), action: 'high-five-another-user', sender: 'Bob', receiver: 'Kate')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:03pm'), action: 'comment', content: 'Sorry about earlier Kate <3', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:06pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:15pm'), action: 'enter-the-room', sender: 'Salvatore')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:16pm'), action: 'comment', content: 'Hey Sal!', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:17pm'), action: 'high-five-another-user', sender: 'Bob', receiver: 'Salvatore')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:18pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:19pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:20pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:21pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:22pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:23pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:24pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:25pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:26pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:27pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:28pm'), action: 'comment', content: '...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:29pm'), action: 'comment', content: 'Ok then...', sender: 'Bob')
Event.collection.insert(created_at: DateTime.parse(today + ' 6:30pm'), action: 'high-five-another-user', sender: 'Bob', receiver: 'Bob')

# Tomorrow - we're going viral!
# Set this number high and query the Event Report page to get a hint for performance.
events = 100000
tomorrow = DateTime.parse((Date.today + 1.day).to_s + ' 12:00pm')
# We use a not-so-perfect hashing function to intentionally cause collisions
#   (one user performing more than one action)
random_string = lambda { (0..(rand(10) + 2)).map { ('a'..'z').to_a[rand(26)] }.join }
events.times do
  event = {}
  content = sender = receiver = random_string.call
  action = Event::Actions.sample
  event[:created_at] = tomorrow
  event[:action] = action
  event[:content] = content if Event::ActionsWithContent.include?(action)
  event[:receiver] = receiver if Event::ActionsWithReceiver.include?(action)
  event[:sender] = sender
  Event.collection.insert(event)
end
