# lesson_controller.rb

require_relative 'application_controller'
require_relative '../models/course'
require_relative '../models/lesson'
require_relative '../models/day'

class LessonController < ApplicationController
  before do
    check_admin_auth if request.path_info == '/new'
    check_admin_auth if [ :post, :patch, :delete ].include? request.request_method.downcase.to_sym

    if params.values_at('id')
      lesson_id = params.values_at('id')
      lesson = Lesson.where(:id => lesson_id).first
      not_found unless lesson
    end
  end

  get '/' do
    @title = 'All Lessons'
    @lesson = Lesson.all
    haml :'lesson/index'
  end

  get '/new' do
    @title = 'Create a new Lesson'
    @lesson = Lesson.new
    @courses = Course.all
    @days = Day.all
    haml :'lesson/new'
  end

  post '/new' do
    @lesson = Lesson.new(params[:lesson])
    unless @lesson.valid?
      @errors = @lesson.errors
      @courses = Course.all
      haml :'lesson/new'
    end

    if @lesson.save
      redirect "/admin/lessons"
    else
      @errors = @lesson.errors
      @courses = Course.all
      @days = Day.all
      haml :'lesson/new'
    end
  end

  get '/:id/edit' do
    check_admin_auth
    lesson_id = params.values_at('id')
    @lesson = Lesson.where(:id => lesson_id).first
    @courses = Course.all
    @days = Day.all
    haml :'lesson/edit'
  end

  patch '/:id/?' do
    lesson_id = params.values_at('id')
    @lesson = Lesson.where(:id => lesson_id).first

    if @lesson.update_attributes(params[:lesson])
      @lesson.save
      redirect "/admin/lessons"
    else
      @course = Course.all
      @errors = @lesson.errors
      haml :'lesson/edit'
    end
  end

  delete '/:id/?' do
    lesson_id = params.values_at('id')
    lesson = Lesson.where(:id => lesson_id).first
    lesson.destroy!
    redirect '/admin/lessons'
  end
end 
