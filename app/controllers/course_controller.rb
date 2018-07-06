# course_controller.rb

require_relative './application_controller'
require_relative '../models/category'
require_relative '../models/category'

class CourseController < ApplicationController
  get '/' do
    @courses = Course.all
    if @courses.length.zero?
      @courses = nil
    end

    haml :'course/index'
  end

  get '/new' do
    unless session[:user_id]
      raise notfound # Change to unauthorized
    end

    @title = 'Create a new Course'
    @course = Course.new
    @categories = Category.all
    haml :'course/new'
  end

  post '/new' do
    unless session[:user_id]
      raise notfound # Change to unauthorized
    end

    @course = Course.new(params[:course])
    unless @course.errors
      puts 'errors'
      @errors = @course.errors
      haml :'category/new'
    end

    if @course.save
      redirect '/courses'
    else
      puts 'in esel'
      puts params[:course]
      @errors = @course.errors
      @categories = Category.all
      haml :'course/new'
    end
  end

  get '/:id/edit' do
    course_id = params.values_at('id')
    @course = Course.where(:id => course_id).first
    @categories = Category.all
    unless @course
      raise notfound # Change to Course not found
    end

    haml :'course/edit'
  end

  post '/:id/edit' do
    course_id = params.values_at('id')
    @course = Course.where(:id => course_id).first

    unless @course
      raise notfound # Change to Course notfound
    end

    @course[:name] = params[:course]['name']
    @course[:description] = params[:course]['description']
    @course[:category_id] = params[:course]['category_id']
    if @course.update_attributes(params[:course])
      puts 'in updaet'
      @course.save
      redirect '/courses'
    else
      @categories = Category.all
      haml :'course/edit'
    end
  end

  delete '/:id/delete' do
    course_id = params.values_at('id')
    @course = Course.where(:id => course_id).first

    unless @course
      return notfound # Return Course not found
    end

    @course.destroy!
    redirect '/courses'
  end
end
