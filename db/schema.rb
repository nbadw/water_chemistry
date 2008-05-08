# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "activities", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.text     "desc"
    t.string   "category",   :default => "", :null => false
    t.string   "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agencies", :primary_key => "code", :force => true do |t|
    t.string   "name"
    t.string   "agency_type"
    t.boolean  "data_rules"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aquatic_site_usages", :force => true do |t|
    t.integer  "aquatic_site_id"
    t.integer  "aquatic_activity_code"
    t.string   "aquatic_site_type"
    t.string   "agency_code"
    t.string   "agency_site_id"
    t.string   "start_year"
    t.string   "end_year"
    t.string   "years_active"
    t.datetime "incorporated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aquatic_sites", :force => true do |t|
    t.integer  "old_aquatic_site_id"
    t.integer  "river_system_id"
    t.integer  "waterbody_id"
    t.string   "name"
    t.string   "description"
    t.string   "habitat_desc"
    t.integer  "reach_no"
    t.string   "start_desc"
    t.string   "end_desc"
    t.float    "start_route_meas"
    t.float    "end_route_meas"
    t.string   "site_type"
    t.boolean  "specific_site"
    t.boolean  "georeferenced"
    t.datetime "entered_at"
    t.datetime "incorporated_at"
    t.string   "coordinate_source"
    t.string   "coordinate_system"
    t.string   "coordinate_units"
    t.string   "x_coord"
    t.string   "y_coord"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "rolename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "password_reset_code",       :limit => 40
    t.boolean  "enabled",                                 :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_code"
  end

  create_table "waterbodies", :force => true do |t|
    t.string   "name"
    t.string   "abbrev_name"
    t.string   "alt_name"
    t.string   "drainage_code"
    t.string   "waterbody_type"
    t.integer  "waterbody_complex_id"
    t.boolean  "surveyed"
    t.integer  "flows_into_waterbody_id"
    t.string   "flows_into_waterbody_name"
    t.string   "flows_into_watershed"
    t.datetime "date_entered"
    t.datetime "date_modified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "watersheds", :primary_key => "drainage_code", :force => true do |t|
    t.string   "name"
    t.string   "unit_type"
    t.boolean  "border"
    t.integer  "stream_order"
    t.float    "area_ha"
    t.float    "area_percent"
    t.string   "drains_into"
    t.string   "level1_no"
    t.string   "level1_name"
    t.string   "level2_no"
    t.string   "level2_name"
    t.string   "level3_no"
    t.string   "level3_name"
    t.string   "level4_no"
    t.string   "level4_name"
    t.string   "level5_no"
    t.string   "level5_name"
    t.string   "level6_no"
    t.string   "level6_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
