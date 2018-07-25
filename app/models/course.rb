# course.rb

# Manages Courses
class Course < ActiveRecord::Base
  validates :name,
            presence: { message: 'Course Name must be provided' }
  validates :description,
            presence: { message: 'Course Description must be provided' }
  validates :category_id, presence: { message: 'Category  must be selected' }
  belongs_to :category
  has_many :lessons
  has_many :enrollments
  has_many :users, through: :enrollments
end
