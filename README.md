# Actionable

Actionable description TODO.

## Installation

Since gem is still in private repository you can install it by adding this to you Gemfile:

    gem 'actionable', git: 'git@github.com:pawelszymanski/actionable-gem.git'

And then execute:

    $ bundle install

To include gem file into your assets you need to edit

1. app/assets/javascripts/application.js` and add this line

        //= require actionable

2.a. `app/assets/stylesheets/application.css` and add this line

        //= require actionable

2.b. `app/assets/stylesheets/application.css.sass` and add this line

        @import actionable

