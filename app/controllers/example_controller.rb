# example_controller.rb
require_relative './application_controller'

# Example Controller
class ExampleController < ApplicationController
  get '/' do
    @title = 'Example Page'
    haml :example
  end
end
