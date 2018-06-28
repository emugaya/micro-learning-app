# example_controller.rb
require_relative 'application_controller.rb'

# Example Controller
class ExampleController < ApplicationController
  get '/' do
    @title = 'Example Page'
    haml :example
  end
end
