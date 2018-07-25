# admin_controller.rb
require_relative './application_controller'
require_relative '../models/category'
require_relative '../models/course'
require_relative '../models/lesson'

# Admin Controller for all admin views
class AdminController < ApplicationController
  before do
    @title = 'Admin Console'
    check_admin_auth
  end

  get '/' do
    haml :'admin/index'
  end

  get '/categories' do
    @categories = Category.all
    haml :'admin/categories'
  end

  get '/courses' do
    @courses = Course.all
    haml :'admin/courses'
  end

  get '/lessons' do
    @lessons = Lesson.all
    haml :'admin/lessons'
  end
end
