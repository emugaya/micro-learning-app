# application_controller.rb
require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'
require 'rack'
require 'warden'
require_relative '../helpers/application_helper.rb'

# Initializes the main application controller where all other controllers
# inherit from
class ApplicationController < Sinatra::Base
  # Set Authentication using Warden
  use Rack::Session::Cookie, secret: ENV['SESSION_SECRET_KEY']

  use Warden::Manager do |config|
    # serialize user to session ->
    config.serialize_into_session(&:id)
    # serialize user from session <-
    config.serialize_from_session { |id| User.find(id) }
    # configuring strategies
    config.scope_defaults :default,
                          strategies: [:password]
    config.failure_app = self
  end

  # Add Warden Strategies
  Warden::Strategies.add(:password) do
    # valid params for authentication
    def valid?
      user_params = params['user']
      user_params && user_params['email_address'] && user_params['password']
    end

    # Authenticate user
    def authenticate!
      user = User.find_by(
        email_address: params['user']['email_address'].downcase
      )
      success!(user) if user
      success!(User.new) unless user
    end
  end

  # Warden Handler
  def warden_handler
    env['warden']
  end

  # Current User
  def current_user
    warden_handler.user
  end

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
end
