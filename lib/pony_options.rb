require 'pony'

Pony.options = {
  via: :smtp,
  via_options: {
    address: 'smtp.gmail.com',
    port: 587,
    user_name: ENV['EMAIL_USERNAME'],
    password: ENV['EMAIL_PASSWORD'],
    authentication: ENV['EMAIL_AUTHENTICATION']
  },
  from: 'jifunze.app@gmail.com'
}
