# Rakefile
require 'rake/testtask'
require 'sinatra/activerecord/rake'
require_relative './app/controllers/application_controller'
require_relative './app/controllers/course_controller'
require_relative './app/models/enrollment'


# Run tests
Rake::TestTask.new do |task|
  task.test_files = FileList['spec/**/*_spec.rb']
end

# Send daily email
desc 'Send user daily email'
task :lessons do 
  CourseController.send_daily_lesson
end

task default: :test
