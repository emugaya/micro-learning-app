# course_model_spec.rb

RSpec.describe Course, type: :model do
  let!(:category) { create :category }
  let!(:course) { create :course }
  let!(:lesson) { create :lesson }

  context 'when creating courses' do
    it_behaves_like 'an invalid object', :invalid_course
    it_behaves_like 'a valid object', :course
    it { is_expected.to validate_presence_of(:name).with_message('Course Name must be provided') }
    it { is_expected.to validate_presence_of(:description).with_message('Course Description must be provided') }
    it { is_expected.to validate_presence_of(:category_id).with_message('Category  must be selected') }
  end

  context 'when retrieving enrollments, lessons and users' do
    it { is_expected.to have_many(:lessons) }
    it { is_expected.to have_many(:enrollments) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to belong_to(:category) }
  end
end
