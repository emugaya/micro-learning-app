# category_controller.rb
require_relative './application_controller'
require_relative '../models/category'
require_relative '../models/course'
require_relative '../models/enrollment'

class CategoryController < ApplicationController
  before do
    validate_access(request.request_method.downcase.to_sym, request.path_info)
  end

  get '/' do
    @categories = Category.all
    @categories = nil if @categories.length.zero?
    haml :'category/index'
  end

  get '/new/?' do
    @title = 'Create a new Category'
    @category = Category.new
    haml :'category/new'
  end

  post '/' do
    @category = Category.new(params[:category])
    unless @category.valid?
      @errors = @category.errors
      return haml :'category/new'
    end
    redirect '/admin/categories' if @category.save
  end

  get '/:id/edit/?' do
    check_admin_auth
    category_id = params.values_at('id')
    @category = Category.find_by(id: category_id)
    not_found unless @category
    haml :'category/edit'
  end

  patch '/:id/?' do
    category_id = params.values_at('id')
    @category = Category.find_by(id: category_id)
    not_found unless @category
    category = params[:category]
    if category[:name].length.zero? || category[:description].length.zero?
      @error = 'Name and Description must be provided'
      return haml :'category/edit'
    end

    @category.update_attributes(params[:category])
    redirect '/admin/categories'
  end

  get '/:id/courses/?' do
    category_id = params.values_at('id')
    @category = Category.find_by(id: category_id)
    not_found unless @category
    @enrolled_course_ids = []
    if current_user
      my_courses = current_user.enrollments.where(status: 'active')
      my_courses.each { |enrollment| @enrolled_course_ids.push(enrollment.id) }
    end

    @courses = @category.courses
    haml :'category/courses'
  end

  delete '/:id/?' do
    category_id = params.values_at('id')
    @category = Category.find_by(id: category_id)
    not_found unless @category
    @category.destroy!
    redirect '/admin/categories'
  end
end
