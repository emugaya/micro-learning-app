# spec_helper.rb
require 'rack/test'
require 'rspec'
require 'sinatra'
require 'simplecov'
require 'spec'
require 'pony'
require 'database_cleaner'
require 'factory_bot'
require 'faker'
require_relative './helpers/controller_helpers'

ENV['RACK_ENV'] ||= 'test'
SimpleCov.start do
  add_filter 'spec'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Controllers', 'app/controllers'
end

module RSpecMixin
  include Rack::Test::Methods
  include Helpers::Controllers
  include Warden::Test::Helpers
  Pony.override_options = { via: :test }
  def app
    described_class
  end
end

# For RSpec 2.x and 3.x
RSpec.configure do |config|
  config.include RSpecMixin
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.before do
    DatabaseCleaner.strategy = :truncation
  end

  config.after do
    DatabaseCleaner.clean
    Warden.test_reset!
  end
end
