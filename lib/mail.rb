require 'mail'

Mail.defaults do
  delivery_method :smtp, {
    :address => ENV['EMAIL_ADDRESS'],
    :port => 587,
    :user_name => ENV['EMAIL_USERNAME'],
    :password => ENV['EMAIL_PASSWORD'],
    :authentication => ENV['EMAIL_AUTHENTICATION'],
    :enable_starttls_auto => true
  }
end
