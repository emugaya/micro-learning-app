# spec/admin_controller_spec.rb
require_relative '../../app/controllers/admin_controller'

RSpec.describe AdminController do
  let(:admin_user) { create :admin_user }
  let(:non_admin_user) { create :non_admin_user }

  context 'when accessing admin console' do
    it 'allows admins' do
      login_as admin_user
      get '/'
      expect(last_response.body).to include('Create, Update, & Delete Courses')
      expect(last_response).to be_ok
    end

    it 'prevents non-admins' do
      login_as non_admin_user
      get '/'
      expect_redirection_to '/category'
    end

    it 'prevents unregistered users' do
      get '/'
      expect_redirection_to '/category'
    end
  end

  context 'when accessing /admin/categories' do
    it 'allows admins' do
      login_as admin_user
      get '/categories'
      expect(last_response.body).to include('Your Viewiing all Categories Available')
      expect(last_response).to be_ok
    end

    it 'prevents non admin users' do
      login_as non_admin_user
      get '/categories'
      expect_redirection_to '/category'
    end

    it 'prevents unregistered users' do
      get '/categories'
      expect_redirection_to '/category'
    end
  end

  context 'when accessing "/admin/lessons" page' do
    it 'allows admins' do
      login_as admin_user
      get '/lessons'
      expect(last_response.body).to include('Your Viewing all Lessons')
      expect(last_response).to be_ok
    end

    it 'prevents non admin users' do
      login_as non_admin_user
      get '/lessons'
      expect_redirection_to '/category'
    end

    it 'prevents unregistered users' do
      get '/lessons'
      expect_redirection_to '/category'
    end
  end

  context 'when viewing "/admin/courses" page' do
    it 'allows admins' do
      login_as admin_user
      get '/courses'
      expect(last_response.body).to include('Your Viewing all Courses Available')
      expect(last_response).to be_ok
    end

    it 'prevents non admin users' do
      login_as non_admin_user
      get '/courses'
      expect_redirection_to '/category'
    end

    it 'prevents unregistered users' do
      get '/courses'
      expect_redirection_to '/category'
    end
  end
end
