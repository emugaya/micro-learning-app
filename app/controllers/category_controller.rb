# category_controller.rb
require_relative './application_controller'
require_relative '../models/category'

class CategoryController < ApplicationController
  get '/' do
    @categories = Category.all
    haml :'category/index'
  end

  get '/new' do
    @title = 'Create a new Category'
    @category = Category.new()
    haml :'category/new'
  end

  post '/new' do
    unless session[:user_id]
      raise not_found
    end

    params[:category]['user_id'] = session[:user_id]

    unless @category.valid?
      @errors = @category.errors
      haml :'category/new'
    end

    if @category.save
      redirect '/category'
    else
      haml :'category/new'
    end
  end

  get '/:id' do
    category_id = params.values_at('id')
    @category = Category.where(:id => category_id).first
    unless @category
      raise not_found
    end
    puts params.values_at('id')
  end

  get '/:id/edit' do
    category_id = params.values_at('id')
    @category = Category.where(:id => category_id).first
    unless @category
      raise not_found
    end
    haml :'category/edit'
  end

  post '/:id/edit' do
    category_id = params.values_at('id')
    @category = Category.where(:id => category_id).first

    unless @category
      return not_found
    end

    @category[:name] = params[:category]['name']
    @category[:description] = params[:category]['description']
    if @category.update_attributes(params[:category])
      @category.save
      redirect "/category/#{@category.id}"
    else
      haml :'category/edit/'
    end
  end

  delete '/:id' do
    category_id = params.values_at('id')
    @category = Category.where(:id => category_id).first

    unless @category
      raise not_found
    end

    @category.destroy!
    redirect '/category'
  end
end