require 'mail'

Mail.defaults do
  delivery_method :smtp, {
    :address => 'smtp.gmail.com',
    :port => 587,
    :user_name => 'jifunze.app@gmail.com',
    :password => 'Jifunze@4321',
    :authentication => 'plain',
    :enable_starttls_auto => true
  }
end