# spec/lesson_controller_spec.rb
require_relative '../../app/controllers/course_controller'
RSpec.describe CourseController do
  before :each do
    login_as FactoryBot.create(:admin_user, email_address: 'admin.test@test.com', password: 'Test1234')
    FactoryBot.create(:category)
    FactoryBot.create(:course)
    FactoryBot.create(:day)
    FactoryBot.create(:lesson)
  end

  context 'when viewing all courses' do
    it 'allows registered users' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Course One')
    end

    it 'allows unregistered users' do
      logout
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Course One')
    end

    it 'allows only registered users to view enrol button' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Enrol')
    end

    it 'prevents unregistered users from viewing enrol button' do
      logout
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).not_to include('Enrol')
    end
  end

  context 'when creating courses' do
    it 'allows only admins view create course page' do
      get '/new'
      expect(last_response).to be_ok
    end

    it 'prevents non admins to view create course page' do
      logout
      get '/new'
      expect_redirection_to '/category'
    end

    it 'allows admins to create course' do
      post '/', params = { course: attributes_for(:second_course) }
      expect_redirection_to '/admin/courses'
    end

    it 'prevents non admins from creating course' do
      logout
      post '/', params = { course: attributes_for(:second_course) }
      expect_redirection_to '/category'
    end

    it 'validates presence of all fields' do
      post '/', params = { course: attributes_for(:invalid_course, category_id: '') }
      expect(last_response.body).to include('Course Name must be provided')
      expect(last_response.body).to include('Course Description must be provided')
      expect(last_response.body).to include('Category  must be selected')
    end
  end

  context 'viewing a course and related lessons' do
    it 'allows admins to view course lessons' do
      get '/1/lessons'
      expect(last_response).to be_ok
    end

    it 'allows non-admins to view course lessons' do
      logout
      login_as FactoryBot.create(:user, email_address: 'user.test@test.com', password: 'Test1234')
      get '/1/lessons'
      expect(last_response).to be_ok
    end

    it 'allows unregistered to view course lessons' do
      logout
      get '/1/lessons'
      expect(last_response).to be_ok
    end
  end

  context 'when editing a course' do
    it 'prevents editng non existing course' do
      get '/100/edit'
      expect(last_response.body).to include('Page does not exist!')
    end

    it 'prevents non-admins from viewing edit course page' do
      logout
      get '/1/edit'
      expect_redirection_to '/category'
    end

    it 'allows admins to view edit course page' do
      get '/1/edit'
      expect(last_response).to be_ok
    end

    it 'allows admins to edit course succesfully' do
      patch '/1', params = { course: attributes_for(:second_course) }
      expect_redirection_to '/admin/courses'
    end

    it 'validates fileds while editing course' do
      patch '/1', params = { course: attributes_for(:invalid_course,
                                                    category_id: '') }
      expect(last_response.body).to include('Course Name must be provided')
      expect(last_response.body).to include('Course Description must be provided')
    end
  end

  context 'when enrolling user to course' do
    it 'prevents unregisterd users from enrolling' do
      logout
      post '/1/enrol'
      expect_redirection_to '/category'
    end

    it 'enrols registerd users succesfully' do
      post '/1/enrol'
      expect(Mail::TestMailer.deliveries.length).to be(1)
      expect_redirection_to '/courses/1/lessons'
    end
  end

  context 'when withdrawing from course' do
    it 'allows registered users to withdraw' do
      FactoryBot.create(:enrollment)
      patch '/1/withdraw'
      expect_redirection_to '/courses'
    end

    it 'redirects unregistered users to /category' do
      FactoryBot.create(:enrollment)
      logout
      patch '/1/withdraw'
      expect_redirection_to '/category'
    end

    it 'redirects unregistered users to /category' do
      FactoryBot.create(:enrollment)
      logout
      patch '/1/withdraw'
      expect_redirection_to '/category'
    end

    it 'prevents withdrawing from non existing course' do
      patch '/100/withdraw'
      expect(last_response.body).to include('Page does not exist!')
    end
  end

  context 'when deleting course' do
    it 'allows admins to delete course' do
      FactoryBot.create(:course)
      delete '/2'
      expect_redirection_to '/admin/courses'
    end

    it 'denies non-admins from deleting course' do
      logout
      delete '/1'
      expect_redirection_to '/category'
    end
  end
end
