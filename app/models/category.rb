# category.rb

class Category < ActiveRecord::Base
  validates :name,
            presence: { message: 'Category Title must be provided' }
  validates :description,
            presence: { message: 'Category brief description must be provided' }
  has_many :courses
end
