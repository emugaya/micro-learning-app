# spec/spec_helper.rb
require 'rack/test'
require 'sinatra'
require 'spec'
require 'rspec'
require 'simplecov'
require File.expand_path '../app/controllers/application_controller', __dir__

ENV['RACK_ENV'] = 'test'

SimpleCov.start do
end

module RSpecMixin
  include Rack::Test::Methods
  def app
    described_class
  end
end

# For RSpec 2.x and 3.x
RSpec.configure { |c| c.include RSpecMixin }
