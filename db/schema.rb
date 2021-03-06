# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_09_083542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'categories', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'courses', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.bigint 'category_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['category_id'], name: 'index_courses_on_category_id'
  end

  create_table 'days', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'enrollments', force: :cascade do |t|
    t.bigint 'course_id'
    t.bigint 'user_id'
    t.string 'status'
    t.integer 'next_lesson'
    t.datetime 'next_sending_time'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['course_id'], name: 'index_enrollments_on_course_id'
    t.index ['user_id'], name: 'index_enrollments_on_user_id'
  end

  create_table 'lessons', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.string 'url'
    t.bigint 'course_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'day_id'
    t.index ['course_id'], name: 'index_lessons_on_course_id'
    t.index ['day_id'], name: 'index_lessons_on_day_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.string 'email_address'
    t.string 'password_digest'
    t.string 'answer'
    t.boolean 'is_admin'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'courses', 'categories'
  add_foreign_key 'enrollments', 'courses'
  add_foreign_key 'enrollments', 'users'
end
