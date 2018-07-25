# lesson_controller.rb

require_relative 'application_controller'
require_relative '../models/course'
require_relative '../models/lesson'
require_relative '../models/day'

class LessonController < ApplicationController
  before do
    validate_access(request.request_method.downcase.to_sym, request.path_info)
  end

  get '/new' do
    @title = 'Create a new Lesson'
    @lesson = Lesson.new
    @courses = Course.all
    @days = Day.all
    haml :'lesson/new'
  end

  post '/' do
    lesson = Lesson.new(params[:lesson])
    unless lesson.valid?
      @errors = lesson.errors
      @courses = Course.all
      @days = Day.all
      return haml :'lesson/new'
    end
    lesson.save
    redirect '/admin/lessons'
  end

  get '/:id/edit' do
    check_admin_auth
    lesson_id = params.values_at('id')
    @lesson = Lesson.find_by(id: lesson_id)
    not_found unless @lesson
    @courses = Course.all
    @days = Day.all
    haml :'lesson/edit'
  end

  patch '/:id/?' do
    lesson_id = params.values_at('id')
    @lesson = Lesson.find_by(id: lesson_id)

    if @lesson.update_attributes(params[:lesson])
      redirect '/admin/lessons'
    else
      @course = Course.all
      @errors = @lesson.errors
      @courses = Course.all
      @days = Day.all
      haml :'lesson/edit'
    end
  end

  delete '/:id/?' do
    lesson_id = params.values_at('id')
    lesson = Lesson.find_by(id: lesson_id)
    not_found unless lesson
    lesson.destroy!
    redirect '/admin/lessons'
  end
end
