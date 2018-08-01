# category_model_spec.rb

RSpec.describe Category, type: :model do
  let!(:category) { create :category }
  let!(:course) { create :course }
  context 'when creating a category' do
    it_behaves_like 'an invalid object', :invalid_category
    it_behaves_like 'a valid object', :category

    it { is_expected.to validate_presence_of(:name).with_message('Category Title must be provided') }
    it { is_expected.to validate_presence_of(:description).with_message('Category brief description must be provided') }
  end

  context 'category relationships' do
    it { is_expected.to have_many(:courses) }
  end
end
