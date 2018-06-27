# example_controller.rb
require_relative 'application_controller.rb'

# This Controller will is responsible for the homepage,
# user sign up, sign in and signout. It will also handle logic for
# resetting password and static pages
class HomepageController < ApplicationController
  get '/' do
    @title = 'Learn Something new in 30 days'
    haml :index
  end
end
