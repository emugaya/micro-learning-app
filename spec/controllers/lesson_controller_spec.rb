# spec/lesson_controller_spec.rb
require_relative '../../app/controllers/lesson_controller'

RSpec.describe LessonController do
  before :each do
    login_as FactoryBot.create(:admin_user)
    FactoryBot.create(:category)
    FactoryBot.create(:course)
    FactoryBot.create(:day)
    FactoryBot.create(:lesson)
  end

  context 'when creating lesson' do
    it 'allows admins to view create page' do
      get '/new'
      expect(last_response).to be_ok
    end

    it 'denies non-admins to view create page' do
      logout
      login_as FactoryBot.create(:user)
      get '/new'
      expect_redirection_to '/category'
    end

    it 'denies un-registered users to view create page' do
      logout
      get '/new'
      expect_redirection_to '/category'
    end

    it 'creates lesson succesfully' do
      FactoryBot.create(:day, name: 'Day 2')
      post '/', params = {lesson: attributes_for(:lesson, day_id: 2)}
      expect_redirection_to '/admin/lessons'
    end

    it 'validates presence of name' do
      post '/', params = {lesson: attributes_for(:lesson, name: '', day_id: 2)}
      expect(last_response.body).to include('Lesson name must be provided')
    end

    it 'validates presence of description' do
      post '/', params = {lesson: attributes_for(:lesson, description: '', day_id: 2)}
      expect(last_response.body).to include('Lesson Description must be provided')
    end

    it 'validates presence of url' do
      post '/', params = { lesson: attributes_for(:lesson, url: '', day_id: 2) }
      expect(last_response.body).to include("can't be blank")
    end

    it 'validates presence of day' do
      post '/', params = { lesson: attributes_for(:lesson, day_id: '') }
      expect(last_response.body).to include("can't be blank")
    end

    it 'validates presence of course' do
      post '/', params = { lesson: attributes_for(:lesson, day_id: 2, course_id: '') }
      expect(last_response.body).to include("can't be blank")
    end
  end

  context 'when editing lesson' do
    it 'prevents editing non existing lesson' do
      get '/100/edit'
      expect(last_response.body).to include('Page does not exist!')
    end

    it 'allows admin to view lesson edit page' do
      get '/1/edit'
      expect(last_response).to be_ok
    end

    it 'prevents non-admins to view lesson edit page' do
      logout
      get '/1/edit'
      expect_redirection_to('/category')
    end

    it 'allows admin to edit lesson succesfully' do
      patch '/1', params = {lesson: attributes_for(:lesson, name: 'New Test name')}
      expect_redirection_to '/admin/lessons'
    end

    it 'validates fields before editing' do
      patch '/1', params = { lesson: attributes_for(:invalid_lesson) }
      expect(last_response.body).to include("can't be blank")
    end
  end

  context 'when deleting lesson' do
    it 'allows admins to delete lesson' do
      delete '/1'
      expect_redirection_to '/admin/lessons'
    end

    it 'prevents non-admins from deleting lesson' do
      logout
      login_as FactoryBot.create(:user)
      delete '/1'
      expect_redirection_to '/category'
    end

    it 'unregistered users from deleting lesson' do
      logout
      delete '/1'
      expect_redirection_to '/category'
    end
  end
end
