FactoryBot.define do
  factory :day do
    name 'Day 1'
  end

  factory :invalid_day, parent: :day do
    name ''
  end
end
