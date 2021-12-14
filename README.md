# README

A twitter stats app written in Ruby on Rails. It allows a user to log in
using twitter and see their followers tweets etc. I have user Auth0 for
authentication.

The following user stories will be implemented:

###   User Story 1
As a new user, I should be able to signup using my Twitter account.

### User Story 2
As a registered user, I should be able to login and log out.

### User Story 3
As a logged in user, I should be able to see my total number of tweets, total number of followers and total number of users I follow.

### User Story 4
As a logged in user, I should be able to enable/disable weekly report generation for followers statistics. The report then should be generated on every Sunday, starting with one generated instantly once enabled.

#### It should contain the following details:

- Total number of unfollows in last 7 days
- Username and Profile URL of the accounts that unfollowed

### User Story 5
As a logged in user, I should be able to see all my previous weekly reports which were generated.

### Deployment
When all of the above user stories are completed, deploy the app to Heroku or any cloud instance. Please provide the URL to the hosted application for us to review, when submitting the task.

### Testing:
You are expected to write test cases (RSpec or Minitest) for all of the user stories above.

### Bonus

- [ ] Using React for UI
- [ ] App is dockerised
- [ ] Github actions configured for CI/CD

## The object model

1. Signin by Twitter is implemented using Auth0's authentication service.
2. When user logs in, a new `User` is created with
  
    - `twitterid`: a numeric value unique to user, assigned by twitter 
    - `handle`: the twitter user name
    - `enable_report`: boolean, default `true`
3. A sidekiq worker is then assigned to pull the new user's `Follower`s from the Twitter Api and create records in the `followers` table with

    - `twitterid`
    - `handle`
4. `Follower`s have unique column constraints, so records are created using `find_or_create_by` 
5. `User`s and `Follower`s have a `has_and_belongs_to_many` association with each other, as also reflected by the join table in the ERD document in `/docs/ERD.pdf`
6. Removing a `Follower` from the `followers` collection only deletes the record in the join table, so the `Follower` record is still associated with other `User`s and `Report`s
7. Creating a new `User` also schedules a `sidekiq-cron` worker for that user, to generate an _unfollow_ report for them every sunday.
8. Report generation calls the `User`'s `generate_unfollow_report` instance method, which in turn, checks the their `enable_report` flag first and goes ahead with `Report` creation.
9. `generate_unfollow_report`

    - First fetches the `User`'s current `Follower`s from Twitter.
    - These are checked against the records in the `followers` collection.
    - New `Follower`s (for those not already in the collection) are created and saved into the collection.
    - `Follower`s who have unfollowed are removed from the collection.
    - A new `Report` is created with `date` and `total` attributes`.
    - The Array of _unfollowed_ `Follower`s is inserted into the `Report`'s `followers` collection.
10. Routes to the _dashboard_, index of _reports_, and individual _reports_ are all protected using the token returned by Auth0 authentication server.

## Issues remaining to be resolved

1. Need to resolve the errors occurring with minitest. A lot more comprehensive testing is needed for the App.
2. While sidekiq and redis seem to work well in development, in production the jobs get queued but aren't getting executed even when there is nothing in the queue.
3. Need to explore other authentication options.