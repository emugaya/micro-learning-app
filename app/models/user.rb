# user.rb

# Class to manage users using our learning app
class User < ActiveRecord::Base
  has_secure_password

  before_save { |user| user.email_address = email_address.downcase }

  validates :first_name, presence: { message: 'First name must be given please' }
  validates :last_name, presence: { message: 'Last name must be given please' }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address,
            presence: { message: 'Email address must be given please' },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: true, message: 'User with this email already exists, Reset password'}
  validates :password, length: { minimum: 8 }, presence: { message: 'Password must be given please' }
  validates :password_confirmation, presence: true
  has_many :enrollments
  has_many :courses, through: :enrollments
end
