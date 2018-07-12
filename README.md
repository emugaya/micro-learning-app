[![CircleCI](https://circleci.com/gh/emugaya/micro-learning-app/tree/develop.svg?style=svg)](https://circleci.com/gh/emugaya/micro-learning-app/tree/develop)
[![Test Coverage](https://api.codeclimate.com/v1/badges/91b6e3507882303f7c69/test_coverage)](https://codeclimate.com/github/emugaya/micro-learning-app/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/91b6e3507882303f7c69/maintainability)](https://codeclimate.com/github/emugaya/micro-learning-app/maintainability)
# Micro-Learning App
Micro-Learning app is a responsive web application that sends you one page per day about something you want to learn. Could be: a new Language, a random Wikipedia page, React documentation, a page from the CIA World Factbook, anything!

The app is hosted on heroku: https://micro-learning-app-prod.herokuapp.com

### Technologies Used
- Ruby 2.4.1
- Sinatra
- Postgres DB (10.4)
- Bundle
- Rake

## Features
#### Admin Features
- Admins are able to Create, Read, Update and Delete Categories
- Admins are able to Create, Read, Update and Delete Courses
- Admins are able to Create, Read, Update and Delete Lessons

#### Registered User Features
- Registered Users are able to view Categories
- Registered Users are able to view, enrol in a Course or leave a course they are already enrolled in
- Registered Users are able to view Lessons

#### Un-Registered User Features
- They are able to register with the site
- They are able to view categories, courses and lessons. 

## Getting Started
Ensure that you have `Ruby 2.4.1, Postgres DB (10.4), Bundle, Rake`
* Clone the application:

      $ git clone https://github.com/emugaya/micro-learning-app.git

* Change directory to `micro-learning-app`
      
      $ cd micro-learning-app

* Install gems by running 

      $ bundle install

* Update the database configuration in `config/database.yml` with your correct prefferred settings.

* Run `rake db:create` to create your databases test and development

      $ rake db:create

* Run `rake db:migrate` to run migrations.
      $ rake db:migrate

* Start the application by running:

      $ shotgun

  If your developing on MAC, set this `OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` in the terminal before running shotgun like below
      
      $ export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
      $ shotgun

#### Testing
Use the command below to run tests

      $ rspec
