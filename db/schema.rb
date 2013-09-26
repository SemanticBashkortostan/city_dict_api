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

ActiveRecord::Schema.define(:version => 20130926204623) do

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "eng_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cities", ["name"], :name => "index_cities_on_name"

  create_table "metadata", :force => true do |t|
    t.integer  "vocabulary_entry_id"
    t.integer  "city_id"
    t.string   "type_name"
    t.string   "source"
    t.string   "url"
    t.hstore   "other"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "metadata", ["city_id"], :name => "index_metadata_on_city_id"
  add_index "metadata", ["type_name"], :name => "index_metadata_on_type_name"
  add_index "metadata", ["vocabulary_entry_id"], :name => "index_metadata_on_vocabulary_entry_id"

  create_table "vocabulary_entries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "normalized_name"
  end

  add_index "vocabulary_entries", ["name"], :name => "index_vocabulary_entries_on_name"
  add_index "vocabulary_entries", ["normalized_name"], :name => "index_vocabulary_entries_on_normalized_name"

end
