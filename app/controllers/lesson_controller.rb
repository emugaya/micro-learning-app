# lesson_controller.rb

require_relative 'application_controller'
require_relative '../models/course'
require_relative '../models/lesson'
require_relative '../models/day'

class LessonController < ApplicationController
  get '/' do
    @title = 'All Lessons'
    @lesson = Lesson.all
    haml :'lesson/index'
  end

  get '/new' do
    unless session[:user_id]
      raise not_found # Change to unauthorized
    end

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
      redirect "/courses/#{@lesson[:course_id]}/lessons"
    else
      @errors = @lesson.errors
      @courses = Course.all
      @days = Day.all
      haml :'lesson/new'
    end
  end

  get '/:id/edit' do
    lesson_id = params.values_at('id')
    @lesson = Lesson.where(:id => lesson_id).first
    unless @lesson
      raise not_found # Change to this to Lesson not found
    end

    @courses = Course.all
    @days = Day.all
    haml :'lesson/edit'
  end

  post '/:id/edit' do
    lesson_id = params.values_at('id')
    @lesson = Lesson.where(:id => lesson_id).first

    unless @lesson
      raise notfound # Change this to lesson not found
    end

    if @lesson.update_attributes(params[:lesson])
      @lesson.save
      redirect "courses/#{@lesson.course_id}/lessons"
    else
      @course = Course.all
      @errors = @lesson.errors
      haml :'lesson/edit'
    end
  end

  delete '/:id/edit' do
    lesson_id = params.values_at('id')
    @lesson = Lesson.where(:id => lesson_id)
    unless @lesson
      raise not_found
    end

    @lesson.destroy!
    redirect '/lessons'
  end
end 
