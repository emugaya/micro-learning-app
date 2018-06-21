# user.rb

# Users Model
class User < ActiveRecord::Base
  validates :first_name, :lastname, :email_address, :password, presence: true
  validates :password, presence: true, length: { minimum: 8 }
end
