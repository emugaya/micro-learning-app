# category.rb

class Category < ActiveRecord::Base
  validates :name,
            presence: { message: 'Category Title must be provided' }
  validates :description,
            presence: { message: 'Category brief description must be provided' }
  validates :user_id, presence: true
  belongs_to :user
end
