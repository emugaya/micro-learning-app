# spec/example_cotroller_spec.rb
require_relative '../../app/controllers/example_controller.rb'
require_relative '../../spec/spec_helper.rb'

RSpec.describe ExampleController do
  it 'should allow accessing the home page' do
    get '/'
    expect(last_response).to be_ok
  end
end
