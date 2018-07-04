# config.ru
require 'sinatra'
require 'sinatra/base'

# pull in the helpers and controllers
Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

# map the controllers to routes

map('/example') { run ExampleController }
map('/') { run HomepageController }
run ApplicationController
