# course_controller.rb

require_relative './application_controller'
require_relative '../models/enrollment'
require_relative '../models/lesson'
require_relative '../models/user'
require_relative '../../lib/mail'

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
      raise not_found # Change to unauthorized
    end

    @title = 'Create a new Course'
    @course = Course.new
    @categories = Category.all
    haml :'course/new'
  end

  post '/new' do
    unless session[:user_id]
      raise not_found # Change to unauthorized
    end

    @course = Course.new(params[:course])
    unless @course.errors
      @errors = @course.errors
      haml :'category/new'
    end

    if @course.save
      redirect '/courses'
    else
      @errors = @course.errors
      @categories = Category.all
      haml :'course/new'
    end
  end

  get '/:id/lessons' do
    course_id = params.values_at('id')
    @course = Course.where(:id => course_id).first
    unless @course
      raise not_found
    end

    @lessons = Lesson.where(:course_id => course_id)
    haml :'course/lessons'
  end

  get '/:id/edit' do
    course_id = params.values_at('id')
    @course = Course.where(:id => course_id).first
    @categories = Category.all
    unless @course
      raise not_found # Change to Course not found
    end

    haml :'course/edit'
  end

  get '/:id/edit' do
    course_id = params.values_at('id')
    @course = Course.where(:id => course_id).first

    unless @course
      raise not_found # Change to Course notfound
    end
  
    if @course.update_attributes(params[:course])
      @course.save
      redirect '/courses'
    else
      @categories = Category.all
      haml :'course/edit'
    end
  end

  get '/:id/enrol' do
    course_id = params.values_at('id').first
    @course = Course.where(:id => course_id).first
    unless session[:user_id]
      # Notify user that they are unathorized to make the request
    end
    unless @course
      raise not_found # Change to Course not found
    end

    @lessons = Lesson.where(:course_id => course_id)
    if @lessons.length.zero?
      redirect "/courses/#{course_id}/lessons"
      # Inform user that there are no lessons
    end

    @enrollment = Enrollment.new()
    @enrollment['course_id'] = course_id
    @enrollment['user_id'] = session[:user_id]
    @enrollment['status'] = 'new'

    if @enrollment.save!
      puts "#{@enrollment.to_json}, 'is the id'"
      CourseController.send_lesson(@enrollment)
      redirect "/courses/#{course_id}/lessons"
    else
      puts @enrollment.errors[:course_id]
      #flash a notice to user that they could not be enrolled
    end
  end

  delete '/:id/delete' do
    course_id = params.values_at('id')
    @course = Course.where(:id => course_id).first

    unless @course
      raise not_found # Return Course not found
    end

    @course.destroy!
    redirect '/courses'
  end

  def self.send_email
    enrollments = Enrollment.where(:status => ['active']) # Add Sending time condition
    if enrollments.length > 0
      self.email_user(enrollments)
    end
  end

  def self.send_lesson(enrollment)
    if enrollment[:next_lesson] == nil
      @lesson = Lesson.where(:course_id => enrollment[:course_id], :day_id => 1).first
    else
      @lesson = Lesson.where(:course_id => enrollment[:course_id], :day_id => enrollment[:next_lesson]).first
    end

    mail_recipient = User.where(:id => enrollment[:user_id]).first[:email_address]

    mail_subject = "Day #{@lesson[:day_id]} Lesson: #{@lesson[:name]}"
    template = File.read('app/views/mail/email.haml')
    haml_engine = Haml::Engine.new(template)
    mail_template = haml_engine.render(Object.new, :lesson => @lesson)
    mail = Mail.new do
      from 'jifunze.app@gmail.com'
      to mail_recipient
      subject mail_subject
      html_part do
        content_type 'text/html; charset=UTF-8'
        body mail_template
      end
    end

    #Send Email
    mail.deliver!

    #Start
    @next_lesson = @lesson[:day_id] + 1
    @update_enrollment = Enrollment.where(:id => enrollment[:id]).first
    if Lesson.where(:day_id => @next_lesson, :course_id =>enrollment[:course_id], ).first
      status = 'active'
      @update_enrollment.update_attributes(
        :next_sending_time => Time.now+2592000, 
        :status => status,
        :next_lesson => @next_lesson)
      @update_enrollment.save!
    else
      status = 'completed'
      @update_enrollment.update_attributes(
        :next_sending_time => Time.now+2592000,
        :status => status)
        @update_enrollment.save!
    end
  end

  def self.email_user(enrollment)
    if enrollment.length >= 2
      length = enrollment.length
      first_half = enrollment.length/2
      email_thread_one = Thread.new{email_user(enrollment[0, first_half])}
      email_thread_two = Thread.new{email_user(enrollment[first_half, (length-first_half)])}
      email_thread_one.join
      email_thread_two.join
    else
      self.send_lesson(enrollment[0])
    end
  end
end
