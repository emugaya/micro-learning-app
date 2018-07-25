# spec/category_controller_spec.rb
require_relative '../../app/controllers/category_controller'

RSpec.describe CategoryController do
  before :each do
    login_as FactoryBot.create(:admin_user, email_address: 'admin.test@test.com', password: 'Test1234')
    FactoryBot.create(:category)
  end

  context 'when viewing all categories' do
    it 'allows unregistered users' do
      logout
      get '/'
      expect(last_response).to be_ok
    end

    it 'allows registered users' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  context 'when accessing create category page' do
    it 'allows admins' do
      get '/new'
      expect(last_response).to be_ok
    end

    it 'does not allow unregistered' do
      logout
      get '/new'
      expect_redirection_to '/category'
    end

    it 'does not allow non admin users' do
      logout
      login_as FactoryBot.create(:user)
      get '/new'
      expect_redirection_to '/category'
    end
  end

  context 'when creating category' do
    it 'allows admin users to create succesfully' do
      post '/', params = { category: attributes_for(:category)}
      expect_redirection_to '/admin/categories'
    end

    it 'validates presence of name' do
      post '/', params = { category: attributes_for(:category, name: '')}
      expect(last_response.body).to include('Category Title must be provided')
    end

    it 'validates presence of description' do
      post '/', params = { category: attributes_for(:category, description: '')}
      expect(last_response.body).to include('Category brief description must be provided')
    end

    it 'denies non-admins and redirects them to /category'  do
      logout
      login_as FactoryBot.create(:user)
      post '/', params = { category: attributes_for(:category)}
      expect_redirection_to '/category'
    end

    it 'denies unregistered users and redirects them to /category' do
      logout
      post '/', params = { category: attributes_for(:category)}
      expect_redirection_to '/category'
    end
  end

  context 'when editing category' do
    it 'prevents editing non-existing category' do
      get '/3/edit'
      expect(last_response.body).to include('Page does not exist!')
    end

    it 'does not allow non-admins and redirects to "/category"' do
      logout
      patch '/1', params = { category: attributes_for(:category) }
      get '/1/edit'
      expect_redirection_to '/category'
    end

    it 'allows admins to view edit form' do
      get '/1/edit'
      expect(last_response).to be_ok
    end

    it 'allows admin to edit' do
      patch '/1', params = {
        category: {
          name: 'Test Category 4',
          description: 'Test category description'
        }
      }
      expect_redirection_to '/admin/categories'
    end

    it 'doesnot allow empty title/name' do
      patch '/1', params = { category:
        { name: '', descriptio: 'Category description' } }
      expect(last_response.body).to include('Name and Description must be provided')
    end

    it 'doesnot allow empty description' do
      patch '/1', params = { category:
        { name: 'Category', description: '' } }
      expect(last_response.body).to include('Name and Description must be provided')
    end
  end

  context 'when user clicks on a category' do
    it 'allows admin users' do
      FactoryBot.create(:course)
      FactoryBot.create(:course)
      FactoryBot.create(:lesson)
      FactoryBot.create(:enrollment)
      FactoryBot.create(:enrollment, status: 'active', course_id: 2)
      get '/1/courses'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Category One')
    end

    it 'allows non-admin users' do
      logout
      login_as FactoryBot.create(:user)
      get '/1/courses'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Category One')
    end

    it 'allows un-registered users' do
      logout
      get '/1/courses'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Category One')
    end
  end

  context 'when deleting category' do
    it 'allows admin users' do
      delete '/1'
      expect_redirection_to '/admin/categories'
    end

    it 'denies non-admin users' do
      logout
      login_as FactoryBot.create(:user)
      delete '/1'
      expect_redirection_to '/category'
    end

    it 'denies unregistered users' do
      FactoryBot.create(:category)
      logout
      delete '/1'
      expect_redirection_to '/category'
    end
  end
end
