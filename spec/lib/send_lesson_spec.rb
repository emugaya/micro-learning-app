# send_lesson_spec.rb
require_relative '../../lib/send_lesson'

RSpec.describe SendLesson do
  let!(:user) { create :non_admin_user}
  let!(:category) { create :category}
  let!(:course) { create :course}
  let!(:lesson) { create :lesson}
  let!(:enrollment) { create :enrollment, next_lesson: 1, next_sending_time: Time.now }

  context 'when sending lessons' do
    it 'sends out daily email lessons' do
      FactoryBot.create(:admin_user)
      FactoryBot.create(:enrollment, user_id: 2, next_lesson: 1, next_sending_time: Time.now)
      FactoryBot.create(:lesson, day_id: 2)
      SendLesson.send_daily_lesson
      expect(Mail::TestMailer.deliveries.length).to be(3)
      expect(Enrollment.find(1)[:status]).to eq('active')
    end

    it 'changes enrollment status to completed if last lesson is sent' do
      SendLesson.send_daily_lesson
      expect(Enrollment.find(1)[:status]).to eq('completed')
    end
  end
end
