# README

A twitter stats app written in Ruby on Rails. It allows a user to log in
using twitter and see their followers tweets etc. I have user Auth0 for
authentication.

The following user stories will be implemented:

### User Story 1
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
