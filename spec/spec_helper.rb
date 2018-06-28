#spec/spec_helper.rb

require 'rack/test'
require 'rspec'
require 'simplecov'
require 'sinatra'
require 'spec'

require_relative '../app/controllers/application_controller.rb'

ENV['RACK_ENV'] = 'test'

SimpleCov.start do
  add_filter 'spec'

  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
end

module RSpecMixin
  include Rack::Test::Methods
  def app
    described_class
  end
end

# For RSpec 2.x and 3.x
RSpec.configure { |c| c.include RSpecMixin }
