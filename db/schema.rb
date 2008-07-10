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

ActiveRecord::Schema.define(:version => 1) do

  create_table "agencies", :force => true do |t|
    t.string   "code",        :limit => 10,                     :null => false
    t.string   "name",        :limit => 120
    t.string   "type",        :limit => 8
    t.boolean  "data_rules",                 :default => false
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aquatic_activities", :force => true do |t|
    t.string   "name",        :limit => 100
    t.string   "category",    :limit => 60
    t.string   "duration",    :limit => 40
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aquatic_activity_events", :force => true do |t|
    t.string   "project",                    :limit => 200
    t.string   "permit_no",                  :limit => 40
    t.integer  "aquatic_program_id"
    t.integer  "aquatic_activity_id"
    t.integer  "aquatic_activity_method_id"
    t.integer  "aquatic_site_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "agency_id"
    t.integer  "agency2_id"
    t.string   "agency2_contact",            :limit => 100
    t.string   "activity_leader",            :limit => 100
    t.string   "crew",                       :limit => 100
    t.string   "weather_conditions",         :limit => 100
    t.float    "water_temperature_c"
    t.float    "air_temperature_c"
    t.string   "water_level",                :limit => 12
    t.string   "water_level_cm",             :limit => 100
    t.string   "morning_water_level_cm",     :limit => 100
    t.string   "evening_water_level_cm",     :limit => 100
    t.string   "siltation",                  :limit => 100
    t.boolean  "primary_activity"
    t.string   "comments",                   :limit => 500
    t.string   "rainfall_last24"
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aquatic_activity_events", ["aquatic_program_id"], :name => "index_aquatic_activity_events_on_aquatic_program_id"
  add_index "aquatic_activity_events", ["aquatic_activity_id"], :name => "index_aquatic_activity_events_on_aquatic_activity_id"
  add_index "aquatic_activity_events", ["aquatic_activity_method_id"], :name => "index_aquatic_activity_events_on_aquatic_activity_method_id"
  add_index "aquatic_activity_events", ["aquatic_site_id"], :name => "index_aquatic_activity_events_on_aquatic_site_id"
  add_index "aquatic_activity_events", ["agency_id"], :name => "index_aquatic_activity_events_on_agency_id"
  add_index "aquatic_activity_events", ["agency2_id"], :name => "index_aquatic_activity_events_on_agency2_id"

  create_table "aquatic_activity_methods", :force => true do |t|
    t.integer  "aquatic_activity_id"
    t.string   "method",              :limit => 60
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aquatic_activity_methods", ["aquatic_activity_id"], :name => "index_aquatic_activity_methods_on_aquatic_activity_id"

  create_table "aquatic_site_usages", :force => true do |t|
    t.integer  "aquatic_site_id"
    t.integer  "aquatic_activity_id"
    t.string   "aquatic_site_type",   :limit => 60
    t.integer  "agency_id"
    t.string   "agency_site_id",      :limit => 32
    t.string   "start_year",          :limit => 4
    t.string   "end_year",            :limit => 4
    t.string   "years_active",        :limit => 40
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aquatic_site_usages", ["aquatic_site_id"], :name => "index_aquatic_site_usages_on_aquatic_site_id"
  add_index "aquatic_site_usages", ["aquatic_activity_id"], :name => "index_aquatic_site_usages_on_aquatic_activity_id"
  add_index "aquatic_site_usages", ["agency_id"], :name => "index_aquatic_site_usages_on_agency_id"

  create_table "aquatic_sites", :force => true do |t|
    t.string   "name",              :limit => 200
    t.string   "description",       :limit => 500
    t.string   "comments",          :limit => 300
    t.integer  "waterbody_id"
    t.string   "coordinate_source", :limit => 100
    t.integer  "coordinate_srs_id"
    t.string   "x_coordinate",      :limit => 100
    t.string   "y_coordinate",      :limit => 100
    t.integer  "gmap_srs_id"
    t.decimal  "gmap_latitude",                    :precision => 15, :scale => 10
    t.decimal  "gmap_longitude",                   :precision => 15, :scale => 10
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aquatic_sites", ["waterbody_id"], :name => "index_aquatic_sites_on_waterbody_id"

  create_table "instruments", :force => true do |t|
    t.string   "name",        :limit => 100
    t.string   "category",    :limit => 100
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_instrument", :force => true do |t|
    t.integer "measurement_id"
    t.integer "instrument_id"
  end

  create_table "measurement_unit", :force => true do |t|
    t.integer "measurement_id"
    t.integer "unit_of_measure_id"
  end

  create_table "measurements", :force => true do |t|
    t.string   "name"
    t.string   "grouping"
    t.string   "category"
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "bank_measurement", :default => false
  end

  create_table "observable_values", :force => true do |t|
    t.integer  "observation_id"
    t.string   "value"
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "observations", :force => true do |t|
    t.string   "name"
    t.string   "grouping"
    t.string   "category"
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "fish_passage_blocked_observation", :default => false
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["role_id"], :name => "index_permissions_on_role_id"
  add_index "permissions", ["user_id"], :name => "index_permissions_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "rolename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_measurements", :force => true do |t|
    t.integer  "aquatic_site_id"
    t.integer  "aquatic_activity_event_id"
    t.integer  "measurement_id"
    t.integer  "instrument_id"
    t.integer  "unit_of_measure_id"
    t.float    "value_measured"
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bank"
  end

  create_table "site_observations", :force => true do |t|
    t.integer  "aquatic_site_id"
    t.integer  "aquatic_activity_event_id"
    t.integer  "observation_id"
    t.string   "value_observed"
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "fish_passage_blocked",      :default => false
  end

  create_table "units_of_measure", :force => true do |t|
    t.string   "name",        :limit => 100
    t.string   "unit",        :limit => 20
    t.datetime "imported_at"
    t.datetime "exported_at"
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
    t.integer  "agency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["agency_id"], :name => "index_users_on_agency_id"

  create_table "water_chemistry_parameters", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "water_chemistry_sample_results", :force => true do |t|
    t.integer "water_chemistry_sample_id"
    t.integer "water_chemistry_parameter_id"
    t.integer "instrument_id"
    t.integer "unit_of_measure_id"
    t.float   "value"
    t.string  "qualifier"
    t.string  "comment"
  end

  create_table "water_chemistry_samples", :force => true do |t|
    t.integer  "aquatic_activity_event_id"
    t.string   "agency_sample_no",          :limit => 10
    t.float    "sample_depth_in_m"
    t.string   "water_source_type",         :limit => 20
    t.string   "sample_collection_method"
    t.string   "analyzed_by"
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "waterbodies", :force => true do |t|
    t.string   "drainage_code",           :limit => 17
    t.string   "waterbody_type",          :limit => 8
    t.string   "name",                    :limit => 110
    t.string   "abbreviated_name",        :limit => 80
    t.string   "alt_name",                :limit => 80
    t.integer  "waterbody_complex_id"
    t.boolean  "surveyed"
    t.integer  "flows_into_waterbody_id"
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
