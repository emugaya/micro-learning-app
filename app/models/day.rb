# order.rb

class Day < ActiveRecord::Base
  validates :name,
            presence: 'Day Name must be provided'
  has_many :lessons
end
