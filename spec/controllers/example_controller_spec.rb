# spec/example_cotroller__spec.rb
require File.expand_path '../../../app/controllers/example_controller.rb', __FILE__
require File.expand_path '../../spec_helper.rb', __FILE__

RSpec.describe ExampleController do
  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
    # expect(last_response).body
  end

end