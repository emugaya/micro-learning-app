# course_controller.rb

require_relative './application_controller'
require_relative '../models/enrollment'
require_relative '../models/lesson'
require_relative '../models/user'
require_relative '../../lib/mail'

class CourseController < ApplicationController
  DAY = 2592000

  before do 
    check_admin_auth if request.path_info == '/new'
    check_admin_auth if [ :post, :patch, :delete ].include? request.request_method.downcase.to_sym
  end

  get '/' do
    @courses = Course.all
    @enrolled_courses = []
    if session[:user_id]
      @my_courses = Enrollment.where(:user_id => session[:user_id], :status => 'active')
      @my_courses.each {|enrollment| @enrolled_courses.push(enrollment[:course_id])}
    else
      @enrolled_courses = []
    end

    @courses = nil if @courses.length.zero?
    haml :'course/index'
  end

  get '/new' do
    @title = 'Create a new Course'
    @course = Course.new
    @categories = Category.all
    haml :'course/new'
  end

  post '/new' do
    @course = Course.new(params[:course])
    unless @course.errors
      @errors = @course.errors
      haml :'category/new'
    end

    if @course.save
      redirect '/admin/courses'
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
    check_admin_auth
    course_id = params.values_at('id')
    @course = Course.where(:id => course_id).first
    @categories = Category.all
    unless @course
      raise not_found # Change to Course not found
    end

    haml :'course/edit'
  end

  patch '/:id/?' do
    course_id = params.values_at('id')
    @course = Course.where(:id => course_id).first

    unless @course
      raise not_found # Change to Course notfound
    end
  
    if @course.update_attributes(params[:course])
      @course.save
      redirect '/admin/courses'
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
      CourseController.send_lesson(@enrollment)
      redirect "/courses/#{course_id}/lessons"
    else
      #flash a notice to user that they could not be enrolled
    end
  end

  get '/:id/withdraw' do
    course_id = params.values_at('id')
    @course = Enrollment.find_by(:course_id => course_id,
                                 :user_id => session[:user_id],
                                 :status => 'active')

    @course.update_attributes(:status => 'withdrawn') if @course
    redirect '/courses'
  end

  delete '/:id/?' do
    course_id = params.values_at('id')
    @course = Course.where(:id => course_id).first

    unless @course
      raise not_found # Return Course not found
    end

    @course.destroy!
    redirect '/admin/courses'
  end

  def self.send_daily_lesson
    enrollments = Enrollment.where(
      "next_sending_time <= :current_time AND status = :status", 
      {current_time: Time.current, status: 'active'}
      ) # Add Sending time condition
    if enrollments.length > 0
      self.email_user(enrollments)
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

    # Set next lesson to be sent
    @next_lesson = @lesson[:day_id] + 1
    @update_enrollment = Enrollment.where(:id => enrollment[:id]).first
    if Lesson.where(:day_id => @next_lesson, :course_id =>enrollment[:course_id], ).first
      status = 'active'
      @update_enrollment.update_attributes(
        :next_sending_time => Time.now + DAY, 
        :status => status,
        :next_lesson => @next_lesson)
      @update_enrollment.save!
    else
      status = 'completed'
      @update_enrollment.update_attributes(
        :next_sending_time => Time.now + DAY,
        :status => status)
        @update_enrollment.save!
    end
  end
end
