#spec/spec_helper.rb
require 'rack/test'
require 'sinatra'
require 'spec'
require 'rspec'
require 'simplecov'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app/controllers/application_controller.rb', __FILE__
SimpleCov.start do
  add_group 'Models', 'app/models'
  add_group "Controllers", "app/controllers"
end

module RSpecMixin
  include Rack::Test::Methods
  def app() described_class end
end

# For RSpec 2.x and 3.x
RSpec.configure { |c| c.include RSpecMixin }
