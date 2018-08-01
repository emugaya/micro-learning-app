# user_model_spec.rb

RSpec.describe User, type: :model do
  let!(:user) { create :non_admin_user, email_address: 'test1.user1@test.com' }
  let!(:category) { create :category }
  let!(:course) { create :course }
  let!(:lesson) { create :lesson }
  let!(:enrollment) { create :enrollment }
  context 'when creating a new user' do
    it_behaves_like 'an invalid object', :invalid_user
    it_behaves_like 'a valid object', :admin_user
    it_behaves_like 'a valid object', :non_admin_user

    it { is_expected.to validate_presence_of(:first_name).with_message('First name must be given please') }
    it { is_expected.to validate_presence_of(:last_name).with_message('Last name must be given please') }

    it { is_expected.to validate_presence_of(:email_address).with_message('Email address must be given please') }
    it { is_expected.to validate_uniqueness_of(:email_address).with_message('User with this email already exists, Reset password') }

    it { is_expected.to validate_presence_of(:password).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:password).with_message("is too short (minimum is 8 characters)") }
    it { is_expected.to validate_presence_of(:password_confirmation).with_message("can't be blank") }
  end

  context 'user model relationships' do
    it_behaves_like 'retrieving items', 'user', User, 'enrollments'

    it { is_expected.to have_many(:enrollments) }
    it { is_expected.to have_many(:courses) }
  end
end
