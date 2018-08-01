FactoryBot.define do
  factory :user do
    first_name 'User_First_Name'
    last_name 'User_Last_Name'
    email_address 'user.test@test.com'
    password 'Test1234'
    password_confirmation 'Test1234'
    answer 'Test'
  end

  factory :admin_user, parent: :user do
    email_address 'admin.test@test.com'
    is_admin 'true'
  end

  factory :non_admin_user, parent: :user do
    email_address 'user.test@test.com'
  end
  
  factory :non_admin_user1, parent: :user do
    email_address 'user1.test1@test.com'
  end

  factory :invalid_user, parent: :user do
    first_name ''
    last_name ''
    email_address ''
    password ''
    password_confirmation ''
    answer ''
  end
end
