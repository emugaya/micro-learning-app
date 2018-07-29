# frozen_string_literal: true

source 'https://rubygems.org'

ruby ENV['CUSTOM_RUBY_VERSION'] || '2.4.1'
gem 'activerecord'
gem 'bcrypt'
gem 'bundler'
gem 'haml' 
gem 'pg'
gem 'pony'
gem 'rack-cache'
gem 'rake' 
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'sinatra'
gem 'sinatra-activerecord'
gem 'warden', '1.2.1' 

group :development do
  gem 'derailed_benchmarks'
  gem 'stackprof'
  gem 'shotgun'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot', '~> 4.0', :require => false
  gem 'faker'
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'rspec-simplecov'
  gem 'rack-test'
  gem 'spec'
  gem 'simplecov'
end
