# course.rb

# Manages Courses
class Course < ActiveRecord::Base
  validates :name,
            presence: { message: 'Course Name must be provided' }
  validates :description,
            presence: { message: 'Course Description must be provided' }
  validates :category_id, presence: true
  belongs_to :category
end
