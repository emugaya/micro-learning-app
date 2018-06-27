require 'rake/testtask'
require 'sinatra/activerecord/rake'
require_relative './app/controllers/application_controller'

Rake::TestTask.new do |task|
  task.test_files = FileList['spec/**/*_spec.rb']
end

task default: :test
