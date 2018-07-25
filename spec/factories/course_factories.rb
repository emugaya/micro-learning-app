FactoryBot.define do
  factory :course do
    name 'Course One'
    description 'Description One'
    category_id 1
  end

  factory :second_course, parent: :course do
    name 'Course Two'
    description 'Description Two'
    category_id 1
  end

  factory :invalid_course, parent: :course do
    name ''
    description ''
  end
end
