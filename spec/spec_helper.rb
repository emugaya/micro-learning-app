# spec_helper.rb
require 'rack/test'
require 'rspec'
require 'shoulda-matchers'
require 'sinatra'
require 'simplecov'
require 'spec'
require 'pony'
require 'database_cleaner'
require 'factory_bot'
require 'faker'
require_relative '../app/controllers/application_controller'


ENV['RACK_ENV'] ||= 'test'
SimpleCov.start do
  add_filter 'spec'
  add_group 'Models', 'app/models'
  add_group 'Lib', 'lib'
  add_group 'Controllers', 'app/controllers'
end
Dir["./app/models/**/*.rb"].sort.each { |f| require f}
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

module RSpecMixin
  include Rack::Test::Methods
  include Warden::Test::Helpers
  Pony.override_options = { via: :test }

  def app
    described_class
  end

  def expect_redirection_to(route)
    expect(last_response.redirect?).to be true
    follow_redirect!
    expect(last_request.path).to eq(route)
  end
end

# shoulda matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
  end
end

# For RSpec 2.x and 3.x
RSpec.configure do |config|
  config.include RSpecMixin
  config.include FactoryBot::Syntax::Methods
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
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
