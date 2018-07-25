# enrol.rb

class Enrollment < ActiveRecord::Base
  validates :course_id, presence: true
  validates :user_id, presence: true
  validates :status, presence: true
  belongs_to :course
  belongs_to :user
end
