# Rakefile
require 'rake/testtask'
require 'sinatra/activerecord/rake'
require_relative './app/controllers/application_controller'
require_relative './lib/send_lesson'

# Run tests
Rake::TestTask.new do |task|
  task.test_files = FileList['spec/**/*_spec.rb']
end

# Send daily email
desc 'Send user daily email'
task :lessons do 
  SendLesson.send_daily_lesson
end

task default: :test
