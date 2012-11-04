# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121103154149) do

  create_table "stories", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "full_title"
    t.string   "precision"
    t.boolean  "published"
    t.text     "content"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "bottom_boundry"
    t.integer  "top_boundry"
    t.float    "lat"
    t.float    "long"
  end

  add_index "stories", ["user_id"], :name => "index_stories_on_user_id"

  create_table "time_maps", :force => true do |t|
    t.integer  "story_id"
    t.string   "name"
    t.string   "full_title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "time_maps", ["story_id"], :name => "index_time_maps_on_story_id"

  create_table "time_maps_times", :force => true do |t|
    t.integer  "time_map_id"
    t.string   "name"
    t.integer  "time"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "map"
    t.text     "content"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "time_maps_times", ["time_map_id"], :name => "index_time_maps_times_on_time_map_id"

  create_table "time_markers", :force => true do |t|
    t.integer  "story_id"
    t.string   "name"
    t.string   "full_title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "color"
  end

  add_index "time_markers", ["story_id"], :name => "index_time_markers_on_story_id"

  create_table "time_markers_times", :force => true do |t|
    t.integer  "time_marker_id"
    t.string   "name"
    t.integer  "time"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "content"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "time_markers_times", ["time_marker_id"], :name => "index_time_markers_times_on_time_marker_id"

  create_table "time_stops", :force => true do |t|
    t.integer  "story_id"
    t.string   "name"
    t.string   "full_title"
    t.integer  "time"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "time_stops", ["story_id"], :name => "index_time_stops_on_story_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "permissions",     :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
