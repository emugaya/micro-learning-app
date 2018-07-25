# spec/admin_controller_spec.rb
require_relative '../../app/controllers/admin_controller'

RSpec.describe AdminController do
  before { login_as FactoryBot.create(:admin_user) }

  context 'when accessing admin console' do
    it 'allows admins to view admin console' do
      get '/'
      expect(last_response.body).to include('Create, Update, & Delete Courses')
      expect(last_response.body).to include('Create, Update, & Delete Lessons')
      expect(last_response.body).to include('Create, Update, & Delete Categories')
      expect(last_response).to be_ok
    end

    it 'prevents non-admins from viewing console' do
      logout
      login_as FactoryBot.create(:user, email_address: 'user.test@test.com')
      get '/'
      expect_redirection_to '/category'
    end

    it 'prevents unregistered users from viewing a page' do
      logout
      get '/'
      expect_redirection_to '/category'
    end
  end

  context 'when accessing /admin/categories' do
    it 'should be able to access "/admin/categories" page' do
      get '/categories'
      expect(last_response.body).to include('Your Viewiing all Categories Available')
      expect(last_response.body).to include('Create a Category')
      expect(last_response).to be_ok
    end

    it 'prevents non admin users' do
      logout
      login_as FactoryBot.create(:user, email_address: 'user.test@test.com')
      get '/categories'
      expect_redirection_to '/category'
    end

    it 'prevents unregistered users' do
      logout
      get '/categories'
      expect_redirection_to '/category'
    end
  end

  context 'when accessing "/admin/lessons" page' do
    it 'should be able to access "/admin/lessons" page' do
      get '/lessons'
      expect(last_response.body).to include('Your Viewing all Lessons')
      expect(last_response.body).to include('Create Lesson')
      expect(last_response).to be_ok
    end

    it 'prevents non admin users' do
      logout
      login_as FactoryBot.create(:user, email_address: 'user.test@test.com')
      get '/lessons'
      expect_redirection_to '/category'
    end

    it 'prevents unregistered users' do
      logout
      get '/lessons'
      expect_redirection_to '/category'
    end
  end

  context 'when viewing "/admin/courses" page' do
    it 'should be able to access "/admin/courses" page' do
      get '/courses'
      expect(last_response.body).to include('Your Viewing all Courses Available')
      expect(last_response.body).to include('Create a Course')
      expect(last_response).to be_ok
    end

    it 'prevents non admin users' do
      logout
      login_as FactoryBot.create(:user, email_address: 'user.test@test.com')
      get '/courses'
      expect_redirection_to '/category'
    end

    it 'prevents unregistered users' do
      logout
      get '/courses'
      expect_redirection_to '/category'
    end
  end
end
