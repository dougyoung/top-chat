# TopChat

A simple application to render aggregated events.

## Dependencies

* Ruby version 2.0 or greater
* Mongo DB 2.6.0 or greater
* Gems: Rails 4.1.4, Draper, Slim, RSpec 3

### Why Rails?

Speed of development. A more barebone approach, such as Sinatra, would be quite good as well if we imagined this as an independent aggregation service connecting to the same database as the chat application.
Likewise an evented system such as Event Machine or node.js would be good considerations for the actual chat application, to increase throughput. Without context, however, it is unknowable whether those performance gains would be significant enough to justify in our use case.
Ultimately both of these services could live together in the same Rails application, and this would be likely in a real-world scenario. In the end I decided to use Rails to remain feature flexible and quick-moving.
Moreso the goal is to show the concepts of aggregation, sorting and rendering so I did not want to become mired in the details of implementation.

### Why Mongo?

Assuming the data set is relatively small this could have all been done in application memory. I was personally interested, however, in trying the [Mongo Aggregation Pipeline](http://docs.mongodb.org/manual/core/aggregation-pipeline/). A good number of my clients use or will use Mongo or another NoSQL DB and increasingly they want to analyze and understand their data at a higher level. I thought the experience would be educational.
Finally, while using a relational DBMS such as Postgres may have proved more performant, and its aggregation suite is more mature, the clustering capabilities of NoSQL databases is very appealing and it is likely that a real-world chat application would have implemented it.

### Why Draper?

To keep the views clean and legible.
To maintain the sanctity of object-oriented programming.

### Why Slim?

Concise views.
Could have just as easily gone with haml.

### Why RSpec?

I like the syntax.

## Getting Started

You must have Ruby 2.0 or greater and Mongo DB 2.6.0 or greater installed.

`bundle install`

Optional: Run the seeds file to insert some dummy data. See `db/seeds.rb` for more details.

`bundle exec rake db:seeds`

Run the server:

`bundle exec rails server`

Point your browser to

`http://localhost:3000`

### Running Tests

`bundle exec rake` or `bundle exec rspec`

## Future Feature Ideas

1. Add timezone input / detection for query offset
2. Extend the range of queries beyond 1 day
3. Aggregate over more intervals than realtime and hourly
4. Add support for more than 1 chat room / group

## Future Engineering Features

1. If the CSS gets any more complex we should think about something like [SASS](http://sass-lang.com) / [LESS](http://lesscss.org)
2. We'll need to look at something like [GridFS](http://docs.mongodb.org/manual/core/gridfs) if our report data sets are expected to exceed 16MB

## Performance Next Steps

1. To optimize read performance, at the cost of write performance, we can index events on `date` and `date, action`.
2. If we don't care about validating / censoring the events the application can commit events to the DB asynchronously and publish the message immediately to all clients. With #1 this would increase both response times and read times.
3. Store the report results to DB and seek these before running another report. If expect to run the same report multiple times it would be good to cache them at the cost of another read to the database. We could then index this collection by action and hour for very quick reads. This benefit only applies to queries about the past and would not benefit the current day.
4. Again to optimize read performance we can pre-aggregate the data as it comes in instead of doing this on demand. This would involve creating a record in a collection each day which is incremented with aggregate data on each event request.
5. We can add an in-memory store as a caching layer above the database to keep the mostly likely pre-aggregated / persisted reports ready to serve immediately without a hit to the database.

## Questions / Comments

Thank you! Please reach out to `douglas dot r dot young at gmail dot com` for any questions or comments!
