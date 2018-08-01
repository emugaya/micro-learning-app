# day_model_spec.rb

RSpec.describe Day, type: :model do
  context 'when creating a day' do
    it_behaves_like 'an invalid object', :invalid_day
    it_behaves_like 'a valid object', :day
    it { is_expected.to validate_presence_of(:name).with_message("can't be blank") }
  end

  context 'day relationships' do
    it { is_expected.to have_many(:lessons) }
  end
end
