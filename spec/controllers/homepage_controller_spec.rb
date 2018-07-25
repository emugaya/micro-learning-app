# homepage_controller_spec.rb
require_relative '../../app/controllers/homepage_controller'
RSpec.describe HomepageController do
  before :each do
    FactoryBot.create(:admin_user)
    FactoryBot.create(:user)
  end

  context 'when accessing homepage' do
    it 'allows all users' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Jifunze')
    end
  end

  context 'when sigining up' do
    it 'displays user signup form' do
      get '/signup'
      expect(last_response).to be_ok
      expect(last_response.body).to include('First name')
      expect(last_response.body).to include('Last name')
    end

    it 'signs up a user succesfully and redirect to /signin' do
      post '/signup', params = { user: attributes_for(:user, email_address: 'test@test.com') }
      expect_redirection_to '/signin'
    end

    it 'validates user credentials' do
      post '/signup', params = { user: attributes_for(:invalid_user) }
      expect(last_response.body).to include('First name must be given please')
      expect(last_response.body).to include('Last name must be given please')
    end
  end

  context 'when signing in' do
    it 'signs in admin user succesfully and redirects to /admin' do
      post '/signin', params = { user: attributes_for(:admin_user)}
      expect_redirection_to '/admin'
    end

    it 'signs in non-admin user succesfully and redirects to /category' do
      post '/signin', params = { user: attributes_for(:user)}
      expect_redirection_to '/category'
    end

    it 'redirects user to /category if already signed in' do
      login_as FactoryBot.create(:user, email_address: 'test@test.com')
      get '/signin'
      expect_redirection_to '/category'
    end

    it 'does not sign user who is not registered' do
      post '/signin', params = { user: attributes_for(:user, email_address: 'test@test.com')}
      expect(last_response.body).to include('User Does not exist')
    end
  end

  context 'when resetting password' do
    it 'displays reset password page' do
      get '/reset-password'
      expect(last_response).to be_ok
    end

    it 'resets password succesfully' do
      post '/reset-password', params = { user: attributes_for(:user) }
      post '/save-password', params = { user: { password: 'Test@4321',
                                                password_confirmation: 'Test@4321' }}
      expect_redirection_to '/signin'
    end

    it 'displays the reset password page if user with email address supplied does not exist' do
      post '/reset-password', params = { user: attributes_for(:user,
                                                              email_address: 'fake@test.com')}
      expect(last_response.body).to include('Invalid email address')
    end

    it 'displays the reset password page if answer to security question is incorrect' do
      post '/reset-password', params = { user: attributes_for(:user, answer: 'Wrong') }
      expect(last_response.body).to include('Invalid Answer to security quetions')
    end

    it 'makes sure that passwords being reset match' do
      post '/reset-password', params = { user: attributes_for(:user) }
      post '/save-password', params = { user: { password: 'Test@43211', password_confirmation: 'Test@4321'}}
      expect(last_response.body).to include('Passwords do not match or too short')
    end

    it 'makes sure that password is not too short' do
      post '/reset-password', params = { user: attributes_for(:user)}
      post '/save-password', params = { user: { password: 'Test', password_confirmation: 'Test'}}
      expect(last_response.body).to include('Passwords do not match or too short')
    end

    it 'makes sure that a user exists before saving new reset password' do
      post '/save-password', params = { user: attributes_for(:user, email_address: 'fakeemail@gmail.com') }
      expect_redirection_to '/reset-password'
    end
  end

  context 'when sigining out' do
    it 'signs out user that is logged in' do
      get '/signout'
      expect_redirection_to '/'
    end
  end
end
