# spec/lesson_controller_spec.rb
require_relative '../../app/controllers/lesson_controller'

RSpec.describe LessonController do
  let(:admin_user) { build :admin_user }
  let(:non_admin_user) { build :non_admin_user }
  let(:category) { build :category }
  let(:course) { build :course }
  let(:day) { build :day }
  before :each do
    FactoryBot.create(:lesson)
  end

  context 'when creating lesson' do
    it 'allows admins to view create page' do
      login_as admin_user
      get '/new'
      expect(last_response).to be_ok
    end

    it 'denies non-admins to view create page' do
      login_as non_admin_user
      get '/new'
      expect_redirection_to '/category'
    end

    it 'denies un-registered users to view create page' do
      get '/new'
      expect_redirection_to '/category'
    end

    it 'creates lesson succesfully' do
      login_as admin_user
      post '/', params = {lesson: attributes_for(:lesson)}
      expect_redirection_to '/admin/lessons'
    end

    it 'validates presence of name' do
      login_as admin_user
      post '/', params = {lesson: attributes_for(:lesson, name: '')}
      expect(last_response.body).to include('Lesson name must be provided')
    end

    it 'validates presence of description' do
      login_as admin_user
      post '/', params = {lesson: attributes_for(:lesson, description: '')}
      expect(last_response.body).to include('Lesson Description must be provided')
    end

    it 'validates presence of url' do
      login_as admin_user
      post '/', params = { lesson: attributes_for(:lesson, url: '') }
      expect(last_response.body).to include("can't be blank")
    end

    it 'validates presence of day' do
      login_as admin_user
      post '/', params = { lesson: attributes_for(:lesson, day_id: '') }
      expect(last_response.body).to include("can't be blank")
    end

    it 'validates presence of course' do
      login_as admin_user
      post '/', params = { lesson: attributes_for(:lesson, course_id: '') }
      expect(last_response.body).to include("can't be blank")
    end
  end

  context 'when editing lesson' do
    it 'prevents editing non existing lesson' do
      login_as admin_user
      get '/100/edit'
      expect(last_response.body).to include('Page does not exist!')
    end

    it 'allows admin to view lesson edit page' do
      login_as admin_user
      get '/1/edit'
      expect(last_response).to be_ok
    end

    it 'prevents non-admins to view lesson edit page' do
      get '/1/edit'
      expect_redirection_to('/category')
    end

    it 'allows admin to edit lesson succesfully' do
      login_as admin_user
      patch '/1', params = {lesson: attributes_for(:lesson, name: 'New Test name')}
      expect_redirection_to '/admin/lessons'
    end

    it 'validates fields before editing' do
      login_as admin_user
      patch '/1', params = { lesson: attributes_for(:invalid_lesson) }
      expect(last_response.body).to include("can't be blank")
    end
  end

  context 'when deleting lesson' do
    it 'allows admins to delete lesson' do
      login_as admin_user
      delete '/1'
      expect_redirection_to '/admin/lessons'
    end

    it 'prevents non-admins from deleting lesson' do
      login_as non_admin_user
      delete '/1'
      expect_redirection_to '/category'
    end

    it 'unregistered users from deleting lesson' do
      delete '/1'
      expect_redirection_to '/category'
    end
  end
end
