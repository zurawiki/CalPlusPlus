#Cal++#

Calendars done right.

Built using Ruby on Rails, Omniauth and the Google Calendar API.
Front end made possible by Backbone.js, FullCalendar, and QTip.

Copyright (c) 2013, Zurawicki, Chang, and Liu.
CS51 2013 Final Project

##Installing the Server:##

Install Ruby 1.9.3 with Rails 3.2, preferably with RVM.
Homebrew on Mac is great for this.

In a terminal, open this directory

###Install:###

    bundle install

To install all Ruby and Rails dependencies

###Migrate:###

    bundle exec rake db:setup

will create, migrate, and populate the databases

###Test:###

    bundle exec rake test

Will run the tests

##Running the Server:##

    bundle exec rails server

To run the server. The server can be reached at:
<http://localhost:3000/>

###Training the Classifier:###

You can use the seed data provided to train the classifier.

    bundle exec rake cal:train

Log in using your Gooogle Account and import your google calendars to see them classified.