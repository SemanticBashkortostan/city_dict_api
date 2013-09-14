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

ActiveRecord::Schema.define(:version => 20130914163322) do

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "eng_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cities", ["name"], :name => "index_cities_on_name"

  create_table "vocabulary_entries", :force => true do |t|
    t.integer  "city_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.hstore   "metadata"
  end

  add_index "vocabulary_entries", ["city_id", "name"], :name => "index_vocabulary_entries_on_city_id_and_name"
  add_index "vocabulary_entries", ["city_id"], :name => "index_vocabulary_entries_on_city_id"
  add_index "vocabulary_entries", ["name"], :name => "index_vocabulary_entries_on_name"

end
