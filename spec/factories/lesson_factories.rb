FactoryBot.define do
  factory :lesson do
    course_id 1
    name 'Test Lesson'
    description 'Lesson Description'
    url 'https://sklise.com/2013/03/08/sinatra-warden-auth/'
    day_id 1
  end

  factory :invalid_lesson, parent: :lesson do
    name ''
    description ''
    url ''
  end
end
