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

ActiveRecord::Schema.define(:version => 29) do

  create_table "activities", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.text     "desc"
    t.string   "category",   :default => "", :null => false
    t.string   "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_events", :force => true do |t|
    t.string   "project"
    t.string   "permit_number"
    t.integer  "aquatic_program_id"
    t.integer  "aquatic_activity_code"
    t.integer  "aquatic_method_code"
    t.integer  "old_aquatic_site_id"
    t.integer  "aquatic_site_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "agency_code"
    t.string   "agency2_code"
    t.string   "agency2_contact"
    t.string   "aquatic_activity_leader"
    t.string   "crew"
    t.string   "weather_conditions"
    t.integer  "water_temp_in_celsius",     :limit => 10, :precision => 10, :scale => 0
    t.integer  "air_temp_in_celsius",       :limit => 10, :precision => 10, :scale => 0
    t.string   "water_level"
    t.string   "water_level_in_cm"
    t.string   "morning_water_level_in_cm"
    t.string   "evening_water_level_in_cm"
    t.string   "siltation"
    t.boolean  "primary_activity"
    t.string   "comments"
    t.datetime "entered_at"
    t.datetime "incorporated_at"
    t.datetime "transferred_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_events", ["aquatic_program_id"], :name => "index_activity_events_on_aquatic_program_id"
  add_index "activity_events", ["aquatic_activity_code"], :name => "index_activity_events_on_aquatic_activity_code"
  add_index "activity_events", ["aquatic_method_code"], :name => "index_activity_events_on_aquatic_method_code"
  add_index "activity_events", ["aquatic_site_id"], :name => "index_activity_events_on_aquatic_site_id"
  add_index "activity_events", ["agency_code"], :name => "index_activity_events_on_agency_code"
  add_index "activity_events", ["agency2_code"], :name => "index_activity_events_on_agency2_code"

  create_table "agencies", :primary_key => "code", :force => true do |t|
    t.string   "name"
    t.string   "agency_type"
    t.boolean  "data_rules"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aquatic_activities", :force => true do |t|
    t.integer  "temporary_id"
    t.string   "project"
    t.string   "permit_number"
    t.integer  "aquatic_program_id"
    t.integer  "aquatic_activity_code"
    t.integer  "aquatic_method_code"
    t.integer  "old_aquatic_site_id"
    t.integer  "aquatic_site_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "agency_code"
    t.string   "agency2_code"
    t.string   "agency2_contact"
    t.string   "leader"
    t.string   "crew"
    t.string   "weather_conditions"
    t.integer  "water_temperature_in_celsius", :limit => 10, :precision => 10, :scale => 0
    t.integer  "air_temperature_in_celsius",   :limit => 10, :precision => 10, :scale => 0
    t.string   "water_level"
    t.integer  "water_level_in_cm",            :limit => 10, :precision => 10, :scale => 0
    t.integer  "morning_water_level_in_cm",    :limit => 10, :precision => 10, :scale => 0
    t.integer  "evening_water_level_in_cm",    :limit => 10, :precision => 10, :scale => 0
    t.string   "siltation"
    t.boolean  "primary_activity"
    t.string   "comments"
    t.datetime "entered_at"
    t.datetime "transferred_at"
    t.datetime "incorporated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aquatic_activity_codes", :force => true do |t|
    t.string   "activity"
    t.string   "category"
    t.string   "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aquatic_activity_method_codes", :force => true do |t|
    t.integer  "aquatic_activity_code"
    t.string   "method"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aquatic_site_agency_uses", :force => true do |t|
    t.integer  "aquatic_site_id"
    t.integer  "aquatic_activity_code"
    t.string   "aquatic_site_type"
    t.string   "agency_code"
    t.string   "agency_site_id"
    t.string   "start_year"
    t.string   "end_year"
    t.string   "years_active"
    t.datetime "entered_at"
    t.datetime "incorporated_at"
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

  add_index "aquatic_site_usages", ["aquatic_site_id"], :name => "aquatic_site_id"
  add_index "aquatic_site_usages", ["aquatic_activity_code"], :name => "aquatic_activity_code"
  add_index "aquatic_site_usages", ["agency_code"], :name => "agency_code"

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
    t.decimal  "wgs84_lat",           :precision => 15, :scale => 10
    t.decimal  "wgs84_lon",           :precision => 15, :scale => 10
  end

  add_index "aquatic_sites", ["waterbody_id"], :name => "waterbody_id"

  create_table "environmental_observations", :force => true do |t|
    t.integer  "aguatic_activity_id"
    t.string   "observation_group"
    t.string   "observation"
    t.string   "observation_supp"
    t.integer  "pipe_size_in_cm",          :limit => 10, :precision => 10, :scale => 0
    t.boolean  "fish_passage_obstruction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instrument_codes", :force => true do |t|
    t.string   "instrument_name"
    t.string   "instrument_category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instruments", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lab_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_instruments", :force => true do |t|
    t.integer  "observation_and_measurement_code"
    t.integer  "instrument_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_unit_codes", :force => true do |t|
    t.integer  "observation_and_measurement_code"
    t.integer  "unit_of_measure_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_units", :force => true do |t|
    t.string   "name"
    t.string   "symbol"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "observation_and_measurement_codes", :force => true do |t|
    t.string   "category"
    t.string   "group"
    t.string   "parameter"
    t.string   "parameter_code"
    t.boolean  "values"
    t.string   "o_and_m_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "observation_and_measurement_values", :force => true do |t|
    t.integer  "observation_and_measurement_code"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "samples", :force => true do |t|
    t.integer  "aquatic_activity_id"
    t.integer  "temporary_aquatic_activity_id"
    t.string   "agency_sample_number"
    t.integer  "sample_depth_in_meters",        :limit => 10, :precision => 10, :scale => 0
    t.string   "water_source_type"
    t.integer  "sample_collection_method_code"
    t.string   "analyzed_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit_of_measure_codes", :force => true do |t|
    t.string   "unit_of_measure"
    t.string   "unit_of_measure_abbreviation"
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
    t.string   "agency_code"
  end

  add_index "users", ["agency_code"], :name => "agency_code"

  create_table "water_measurements", :force => true do |t|
    t.integer  "aquatic_activity_id"
    t.integer  "temporary_aquatic_activity_id"
    t.integer  "temperature_data_id"
    t.integer  "temperature_logger_id"
    t.integer  "habitat_unit_id"
    t.integer  "sample_id"
    t.string   "water_source_type"
    t.integer  "water_depth_in_meters",            :limit => 10, :precision => 10, :scale => 0
    t.datetime "time_of_day"
    t.integer  "observation_and_measurement_code"
    t.integer  "instrument_code"
    t.integer  "measurement"
    t.integer  "unit_of_measure_code"
    t.boolean  "detection_limit"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  add_index "waterbodies", ["drainage_code"], :name => "drainage_code"
  add_index "waterbodies", ["flows_into_waterbody_id"], :name => "flows_into_waterbody_id"
  add_index "waterbodies", ["flows_into_watershed"], :name => "flows_into_watershed"

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
