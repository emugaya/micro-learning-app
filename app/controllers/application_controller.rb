# application_controller.rb
require 'sinatra' 
require 'sinatra/base' 
require 'haml'
require_relative '../helpers/application_helper.rb'

class ApplicationController < Sinatra::Base
  enable :sessions
  helpers ApplicationHelper

  #set folder for templates to ../views
  set :views, File.expand_path('../../views', __FILE__)
  configure :production, :development do
    enable :logging
  end

  # get'/' do
  #   "Hello World"
  # end

  not_found do
    title 'Not Found!'
    erb :not_found
  end

end
