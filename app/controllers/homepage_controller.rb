# example_controller.rb
require_relative './application_controller'
require_relative '../models/user'

# This Controller will is responsible for the homepage,
# user sign up, sign in and signout. It will also handle logic for
# resetting password and static pages
class HomepageController < ApplicationController
  get '/' do
    @title = 'Learn Something new in 30 days'
    haml :index
  end

  get '/signup' do
    @title = 'Signup here to start using Jifunze'
    @user = User.new
    haml :'user/signup'
  end

  post '/signup' do
    @user = User.new(params[:user])
    unless @user.valid?
      @errors = @user.errors
      haml :'user/signup'
    end

    if @user.save
      redirect '/signin'
    else
      haml :'user/signup'
    end
  end

  get '/signin' do
    redirect '/category' if  current_user
    @title = 'Signin here to get started'
    haml :'user/signin'
  end

  post '/signin' do
    warden_handler.authenticate!
    if current_user.first_name.nil?
      @not_found = 'User Does not exist'
      return haml :'user/signin'
    else
      redirect '/admin' if current_user.is_admin
      redirect '/category'
    end
  end

  get '/signout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    redirect '/'
  end

  get '/reset-password' do
    @title = 'Resetting Password'
    @user = User.new
    haml :'user/reset-password'
  end

  post '/reset-password' do
    @question_error = ''
    @email_error = ''
    @user = User.find_by(email_address: params[:user]['email_address'])

    if @user.nil?
      @email_error = 'Invalid email address'
      return haml :'user/reset-password'
    end

    unless @user[:answer] == params[:user]['answer']
      @question_error = 'Invalid Answer to security quetions'
      return haml :'user/reset-password'
    end

    session[:resetpassword] = params[:user]['email_address']
    redirect '/new-password'
  end

  get '/new-password' do
    haml :'user/new-password'
  end

  post '/save-password' do
    @password_error = ''
    @user = User.find_by(email_address: session[:resetpassword])

    unless @user
      session[:resetpassword] = nil
      redirect '/reset-password'
    end

    unless (params[:user]['password'] == params[:user]['password_confirmation']) &&
           (params[:user]['password'].length >= 8)
      @password_error = 'Passwords do not match or too short'
      return haml :'user/new-password'
    end

    @user.update_attributes(params[:user])
    @user.save
    session[:resetpassword] = nil
    redirect '/signin'
  end
end
