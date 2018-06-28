# spec/example_cotroller_spec.rb
require_relative '../../app/controllers/example_controller'
require_relative '../spec_helper.rb'

RSpec.describe ExampleController do
  it 'should allow accessing the example page' do
    get '/'
    expect(last_response).to be_ok
  end
end
