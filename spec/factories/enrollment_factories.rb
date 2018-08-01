FactoryBot.define do
  factory :enrollment do
    course_id 1
    user_id 1
    status 'active'
  end

  factory :invalid_enrollment, parent: :enrollment do
    course_id ''
    user_id ''
    status ''
  end
end
