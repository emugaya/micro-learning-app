FactoryBot.define do
  factory :category do
    name 'Category One'
    description 'Description One'
  end

  factory :invalid_category, parent: :category do
    name ''
    description ''
  end
end
