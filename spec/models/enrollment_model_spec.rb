# enrollment_model_spec.rb
require_relative '../../app/models/enrollment'

RSpec.describe Enrollment, type: :model do
  context 'when creating an enrollment' do
    it_behaves_like 'an invalid object', :invalid_enrollment
    it_behaves_like 'a valid object', :enrollment

    it { is_expected.to validate_presence_of(:user_id).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:course_id).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:status).with_message("can't be blank") }
  end

  context 'enrollment relatioships' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:user) }
  end
end
