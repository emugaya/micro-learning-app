# course_controller.rb
require 'pony'
require_relative './application_controller'
require_relative '../models/enrollment'
require_relative '../models/lesson'
require_relative '../models/user'
require_relative '../../lib/send_lesson'

class CourseController < ApplicationController
  before do
    validate_access(request.request_method.downcase.to_sym, request.path_info)
  end

  get '/' do
    @courses = Course.all
    @enrolled_course_ids = []
    if current_user
      @my_courses = current_user.enrollments.where(status: 'active')
      @my_courses.each { |enrollment| @enrolled_course_ids.push(enrollment.id) }
    end

    @courses = nil if @courses.length.zero?
    haml :'course/index'
  end

  get '/new' do
    @title = 'Create a new Course'
    @categories = Category.all
    haml :'course/new'
  end

  post '/' do
    course = Course.new(params[:course])
    if course.save
      redirect '/admin/courses'
    else
      @errors = course.errors
      @categories = Category.all
      haml :'course/new'
    end
  end

  get '/:id/lessons' do
    course_id = params.values_at('id')
    @course = Course.find_by(id: course_id)
    not_found unless @course
    @lessons = @course.lessons
    haml :'course/lessons'
  end

  get '/:id/edit' do
    check_admin_auth
    course_id = params.values_at('id')
    @course = Course.find_by(id: course_id)
    @categories = Category.all
    not_found unless @course
    haml :'course/edit'
  end

  patch '/:id/?' do
    course_id = params.values_at('id')
    @course = Course.find_by(id: course_id)
    not_found unless @course
    if @course.update_attributes(params[:course])
      redirect '/admin/courses'
    else
      @categories = Category.all
      @errors = @course.errors
      haml :'course/edit'
    end
  end

  post '/:id/enrol' do
    course_id = params.values_at('id')
    course = Course.find_by(id: course_id)
    not_found unless course
    redirect "/courses/#{course_id[0]}/lessons" if course.lessons.nil?
    enrollment = Enrollment.new(course_id: course_id[0],
                                user_id: current_user.id,
                                status: 'active')
    enrollment.save!
    SendLesson.send_lesson(enrollment)
    redirect "/courses/#{course_id[0]}/lessons"
  end

  patch '/:id/withdraw' do
    course_id = params.values_at('id')
    enrollment = current_user.enrollments.where(status: 'active',
                                                course_id: course_id).first
    not_found unless enrollment
    enrollment.update_attributes(status: 'withdrawn')
    redirect '/courses'
  end

  delete '/:id/?' do
    course_id = params.values_at('id')
    course = Course.find_by(id: course_id)
    not_found unless course
    course.destroy!
    redirect '/admin/courses'
  end
end
