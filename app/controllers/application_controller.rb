# application_controller.rb
require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'
require_relative '../helpers/application_helper.rb'

# Initializes the main application controller where all other controllers
# inherit from
class ApplicationController < Sinatra::Base
  enable :sessions
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
end
