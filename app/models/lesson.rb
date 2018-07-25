# lesson.rb

class Lesson < ActiveRecord::Base
  validates :name,
            presence: { message: 'Lesson name must be provided' }
  validates :description,
            presence: { message: 'Lesson Description must be provided'}
  validates :url, presence: true
  validates :course_id, presence: true
  validates :day_id, presence: true
  belongs_to :course
end
