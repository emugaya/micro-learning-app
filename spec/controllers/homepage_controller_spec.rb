# homepage_controller_spec.rb
require_relative '../../app/controllers/homepage_controller'
require_relative '../spec_helper.rb'

RSpec.describe HomepageController do
  it 'should be able to access homepage' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Jifunze')
  end

  it 'should login register user' do

  end
end
