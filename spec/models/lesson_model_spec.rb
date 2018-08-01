# lesson_model_spec.rb
require_relative '../../app/models/lesson'

RSpec.describe Lesson, type: :model do
  let(:category) { build :category }
  let(:course) { build :course }
  context 'when creating a lesson' do
    it_behaves_like 'an invalid object', :invalid_lesson
    it_behaves_like 'a valid object', :lesson

    it { is_expected.to validate_presence_of(:name).with_message('Lesson name must be provided') }
    it { is_expected.to validate_presence_of(:description).with_message('Lesson Description must be provided') }
    it { is_expected.to validate_presence_of(:url).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:course_id).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:day_id).with_message("can't be blank") }
  end

  context 'lesson relationships' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:day) }
  end
end
