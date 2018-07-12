# config.ru
require 'sinatra'
require 'sinatra/base'

# pull in the helpers and controllers
Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

# Enable use of PATCH, PUT and DELETE
use Rack::MethodOverride
# map the controllers to routes
map('/example') { run ExampleController }
map('/lessons') { run LessonController}
map('/courses') { run CourseController }
map('/category') { run CategoryController }
map('/admin') { run AdminController }
map('/') { run HomepageController }
