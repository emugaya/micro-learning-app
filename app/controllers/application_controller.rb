# application_controller.rb
require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'
require 'rack'
require_relative '../helpers/application_helper.rb'


# Initializes the main application controller where all other controllers
# inherit from
class ApplicationController < Sinatra::Base
  set :session_secret, ENV['SESSION_SECRET_KEY']
  enable :sessions
  set :root, File.dirname(__FILE__)

  helpers ApplicationHelper

  # set assets folder for static files
  set :public_folder, File.expand_path('../assets', __dir__)

  # set folder for templates to ../views
  set :views, File.expand_path('../views', __dir__)
  configure :production, :development do
    enable :logging
  end

  not_found do
    title 'Not Found!'
    haml :not_found
  end

  before do
    puts 'running before do'
  end
end
