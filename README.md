# Cal++ #

Calendars done right.

Built using Ruby on Rails, Omniauth and the Google Calendar API.
Front end made possible by Backbone.js, FullCalendar, and QTip.

Copyright (c) 2013, Zurawicki, Chang, and Liu.
CS51 2013 Final Project

## Installing the Server ##

Install Ruby 1.9.3 with Rails 3.2, preferably with RVM.
Homebrew on Mac is great for this.

### Install Ruby (UNIX-based systems) ###
1.	Launch terminal on your computer, ruby must first be installed. On Mac OS X, you must install the command-line
    developer tools that can be downloaded in the preferences of Xcode.
2.	Enter the following commands to install Rubygems

	    sudo gem update –system
	    sudo gem install rubygems-update
	    sudo update_rubygems

In a terminal, open this directory

### Install Dependencies ###

    bundle install

To install all Ruby and Rails dependencies

### Migrate Datebases ###

    bundle exec rake db:setup

will create, migrate, and populate the databases

### Test ###

    bundle exec rake test

will run the tests

## Running the Server ##

    bundle exec rails server

To run the server. Note: that if you missed any of the steps above. Rails should guide you through the setup.
The website can be accessed locally on <http://localhost:3000/>.

Note that Cal++ runs best on Google Chrome and WebKit-based browsers such as Safari.


### Training the Classifier ###

You can use the seed data provided to train the classifier.

    bundle exec rake cal:train

## Usage Reference ##
This section is a tutorial of how to use the web app. The work that went into the frontend was a CS50 project and this
is not the focus our CS51 project.

### User Login ###
A Google account is to login and use Cal++. On the welcome page, the user is greeted with a get started button, taking
the user to Google's signin page for authentication. The user must give Cal++ permissions in order to continue. The user
may securely logout at anytime using the sidebar to the left. No information other than the user's name, email, and
calendar info is being stored on Cal++ servers.

### Calendar Import ###
Importing calendars, one of the most useful ways to try out Cal++'s innovative functionality, is done using Google
Calendar's API and the user's Google account. On the left hand side of the calendar, click the button that says “Import
from Google.” All of the user's Google Calendars will display, ready for import. The user can import as many calendars
as they want.

### Adding Events ###
To add an event to the calendar, click the day in month view on which you want the event added. New events can also be
created by clicking anywhere in week view of day view. A form will pop-up prompting the user for relevant information.

### Importance ###
The way we designed our calendar, the user is able to classify an event as important or not. The user can manually
specify importance on the front end client or they can let the server run the classifier to determine importance
automatically. The backend uses a Bayesian classifier to determine the importance of events.

### Changing Dates ###
To move an event to a different date, simply drag the event icon from one date to another, or click on the event and the
popup form will allow you to manually specify the start and end time of your event.

### Event Details ###
To reveal more details about an event, hover over the event icon and a popup will show more information such as the
event name, time, etc.

### Importance Denotation ###
Normal events are denoted by a simple circle on the calendar
Uncertain events are denoted by an outline around the event.
Important events are denoted by a colored outline around the event.
This view allows the user to get a visual understanding of when his or her important events are whether in month, week,
or day view.