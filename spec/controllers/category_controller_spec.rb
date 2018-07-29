# spec/category_controller_spec.rb
require_relative '../../app/controllers/category_controller'

RSpec.describe CategoryController do
  let(:admin_user) { create :admin_user }
  let(:non_admin_user) { create :non_admin_user }
  before :each do
    FactoryBot.create(:category)
  end

  context 'when viewing all categories' do
    it 'allows unregistered users' do
      get '/'
      expect(last_response).to be_ok
    end

    it 'allows registered users' do
      login_as non_admin_user
      get '/'
      expect(last_response).to be_ok
    end
  end

  context 'when accessing create category page' do
    it 'allows admins' do
      login_as admin_user
      get '/new'
      expect(last_response).to be_ok
    end

    it 'does not allow unregistered' do
      get '/new'
      expect_redirection_to '/category'
    end

    it 'does not allow non admin users' do
      login_as non_admin_user
      get '/new'
      expect_redirection_to '/category'
    end
  end

  context 'when creating category' do
    it 'allows admin users to create succesfully' do
      login_as admin_user
      post '/', params = { category: attributes_for(:category)}
      expect_redirection_to '/admin/categories'
    end

    it 'validates presence of name' do
      login_as admin_user
      post '/', params = { category: attributes_for(:category, name: '')}
      expect(last_response.body).to include('Category Title must be provided')
    end

    it 'validates presence of description' do
      login_as admin_user
      post '/', params = { category: attributes_for(:category, description: '')}
      expect(last_response.body).to include('Category brief description must be provided')
    end

    it 'denies non-admins and redirects them to /category'  do
      login_as non_admin_user
      post '/', params = { category: attributes_for(:category)}
      expect_redirection_to '/category'
    end

    it 'denies unregistered users and redirects them to /category' do
      post '/', params = { category: attributes_for(:category)}
      expect_redirection_to '/category'
    end
  end

  context 'when editing category' do
    it 'prevents editing non-existing category' do
      login_as admin_user
      get '/3/edit'
      expect(last_response.body).to include('Page does not exist!')
    end

    it 'does not allow non-admins and redirects to "/category"' do
      patch '/1', params = { category: attributes_for(:category) }
      get '/1/edit'
      expect_redirection_to '/category'
    end

    it 'allows admins to view edit form' do
      login_as admin_user
      get '/1/edit'
      expect(last_response).to be_ok
    end

    it 'allows admin to edit' do
      login_as admin_user
      patch '/1', params = {
        category: {
          name: 'Test Category 4',
          description: 'Test category description'
        }
      }
      expect_redirection_to '/admin/categories'
    end

    it 'doesnot allow empty title/name' do
      login_as admin_user
      patch '/1', params = { category:
        { name: '', description: 'Category description' } }
      expect(last_response.body).to include('Category Title must be provided')
    end

    it 'doesnot allow empty description' do
      login_as admin_user
      patch '/1', params = { category:
        { name: 'Category', description: '' } }
      expect(last_response.body).to include('Category brief description must be provided')
    end
  end

  context 'when user clicks on a category' do
    it 'allows admin users' do
      login_as admin_user
      get '/1/courses'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Category One')
    end

    it 'allows non-admin users' do
      login_as non_admin_user
      get '/1/courses'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Category One')
    end

    it 'allows un-registered users' do
      get '/1/courses'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Category One')
    end
  end

  context 'when deleting category' do
    it 'allows admin users' do
      login_as admin_user
      delete '/1'
      expect_redirection_to '/admin/categories'
    end

    it 'denies non-admin users' do
      login_as non_admin_user
      delete '/1'
      expect_redirection_to '/category'
    end

    it 'denies unregistered users' do
      delete '/1'
      expect_redirection_to '/category'
    end
  end
end
