# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "aquatic_site_usages", :force => true do |t|
    t.integer  "aquatic_site_id",     :limit => 11
    t.integer  "aquatic_activity_id", :limit => 11
    t.string   "aquatic_site_type",   :limit => 60
    t.integer  "agency_id",           :limit => 11
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
    t.string   "name",                      :limit => 200
    t.string   "description",               :limit => 500
    t.string   "comments",                  :limit => 300
    t.integer  "waterbody_id",              :limit => 11
    t.decimal  "gmap_latitude",                            :precision => 15, :scale => 10
    t.decimal  "gmap_longitude",                           :precision => 15, :scale => 10
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gmap_coordinate_system_id", :limit => 11
    t.integer  "coordinate_system_id",      :limit => 11
    t.string   "raw_longitude",             :limit => 20
    t.integer  "coordinate_source_id",      :limit => 11
    t.string   "raw_latitude",              :limit => 20
  end

  add_index "aquatic_sites", ["waterbody_id"], :name => "index_aquatic_sites_on_waterbody_id"

  create_table "cdagency", :force => true do |t|
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agency",       :limit => 60
    t.string   "agencycd",     :limit => 5,                   :null => false
    t.string   "agencytype",   :limit => 4
    t.string   "datarulesind", :limit => 1,  :default => "N"
  end

  create_table "cdaquaticactivity", :primary_key => "aquaticactivitycd", :force => true do |t|
    t.string   "aquaticactivity",         :limit => 50
    t.string   "aquaticactivitycategory", :limit => 30
    t.string   "duration",                :limit => 20
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cdaquaticactivitymethod", :primary_key => "aquaticmethodcd", :force => true do |t|
    t.integer  "aquaticactivitycd", :limit => 11
    t.string   "aquaticmethod",     :limit => 30
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coordinate_sources", :force => true do |t|
    t.string "name", :limit => 30, :null => false
  end

  create_table "coordinate_sources_coordinate_systems", :id => false, :force => true do |t|
    t.integer "coordinate_system_id", :limit => 11, :null => false
    t.integer "coordinate_source_id", :limit => 11, :null => false
  end

  create_table "coordinate_systems", :force => true do |t|
    t.integer "epsg", :limit => 11, :null => false
    t.string  "name",               :null => false
    t.string  "display_name"
    t.string  "type",               :null => false
  end

  create_table "instruments", :force => true do |t|
    t.string   "name",        :limit => 100
    t.string   "category",    :limit => 100
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_instrument", :force => true do |t|
    t.integer "measurement_id", :limit => 11
    t.integer "instrument_id",  :limit => 11
  end

  create_table "measurement_unit", :force => true do |t|
    t.integer "measurement_id",     :limit => 11
    t.integer "unit_of_measure_id", :limit => 11
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
    t.integer  "observation_id", :limit => 11
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
    t.integer  "role_id",    :limit => 11, :null => false
    t.integer  "user_id",    :limit => 11, :null => false
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
    t.integer  "aquatic_site_id",           :limit => 11
    t.integer  "aquatic_activity_event_id", :limit => 11
    t.integer  "measurement_id",            :limit => 11
    t.integer  "instrument_id",             :limit => 11
    t.integer  "unit_of_measure_id",        :limit => 11
    t.string   "value_measured"
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bank"
  end

  create_table "site_observations", :force => true do |t|
    t.integer  "aquatic_site_id",           :limit => 11
    t.integer  "aquatic_activity_event_id", :limit => 11
    t.integer  "observation_id",            :limit => 11
    t.string   "value_observed"
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "fish_passage_blocked",                    :default => false
  end

  create_table "tblaquaticactivity", :primary_key => "aquaticactivityid", :force => true do |t|
    t.integer  "tempaquaticactivityid",    :limit => 11
    t.string   "project",                  :limit => 100
    t.string   "permitno",                 :limit => 20
    t.integer  "aquaticprogramid",         :limit => 11
    t.integer  "aquaticactivitycd",        :limit => 11
    t.integer  "aquaticmethodcd",          :limit => 11
    t.integer  "oldaquaticsiteid",         :limit => 11
    t.integer  "aquaticsiteid",            :limit => 11
    t.string   "aquaticactivitystartdate", :limit => 10
    t.string   "aquaticactivityenddate",   :limit => 10
    t.string   "aquaticactivitystarttime", :limit => 6
    t.string   "aquaticactivityendtime",   :limit => 6
    t.string   "year",                     :limit => 4
    t.string   "agencycd",                 :limit => 4
    t.string   "agency2cd",                :limit => 4
    t.string   "agency2contact",           :limit => 50
    t.string   "aquaticactivityleader",    :limit => 50
    t.string   "crew",                     :limit => 50
    t.string   "weatherconditions",        :limit => 50
    t.float    "watertemp_c"
    t.float    "airtemp_c"
    t.string   "waterlevel",               :limit => 6
    t.string   "waterlevel_cm",            :limit => 50
    t.string   "waterlevel_am_cm",         :limit => 50
    t.string   "waterlevel_pm_cm",         :limit => 50
    t.string   "siltation",                :limit => 50
    t.boolean  "primaryactivityind"
    t.string   "comments"
    t.datetime "dateentered"
    t.boolean  "incorporatedind"
    t.datetime "datetransferred"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "rainfall_last24",          :limit => 15
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency2_id",               :limit => 11
    t.integer  "agency_id",                :limit => 11
  end

  add_index "tblaquaticactivity", ["aquaticsiteid"], :name => "index_tblaquaticactivity_on_aquaticsiteid"
  add_index "tblaquaticactivity", ["agency_id"], :name => "index_tblaquaticactivity_on_agency_id"

  create_table "tbldrainageunit", :force => true do |t|
    t.string  "drainagecd",   :limit => 17, :null => false
    t.string  "level1no",     :limit => 2
    t.string  "level1name",   :limit => 40
    t.string  "level2no",     :limit => 2
    t.string  "level2name",   :limit => 40
    t.string  "level3no",     :limit => 2
    t.string  "level3name",   :limit => 40
    t.string  "level4no",     :limit => 2
    t.string  "level4name",   :limit => 40
    t.string  "level5no",     :limit => 2
    t.string  "level5name",   :limit => 40
    t.string  "level6no",     :limit => 2
    t.string  "level6name",   :limit => 40
    t.string  "unitname",     :limit => 55
    t.string  "unittype",     :limit => 4
    t.string  "borderind",    :limit => 1
    t.integer "streamorder",  :limit => 11
    t.float   "area_ha"
    t.float   "area_percent"
  end

  create_table "tblwaterbody", :primary_key => "waterbodyid", :force => true do |t|
    t.string   "drainagecd",             :limit => 17
    t.string   "waterbodytypecd",        :limit => 4
    t.string   "waterbodyname",          :limit => 55
    t.string   "waterbodyname_abrev",    :limit => 40
    t.string   "waterbodyname_alt",      :limit => 40
    t.integer  "waterbodycomplexid",     :limit => 11
    t.string   "surveyed_ind",           :limit => 1
    t.integer  "flowsintowaterbodyid",   :limit => 11
    t.string   "flowsintowaterbodyname", :limit => 40
    t.string   "flowsintodrainagecd",    :limit => 17
    t.datetime "dateentered"
    t.datetime "datemodified"
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
    t.integer  "agency_id",                 :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login"
  end

  add_index "users", ["agency_id"], :name => "index_users_on_agency_id"

  create_table "water_chemistry_parameters", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "imported_at"
    t.datetime "exported_at"
  end

  create_table "water_chemistry_sample_results", :force => true do |t|
    t.integer "water_chemistry_sample_id",    :limit => 11
    t.integer "water_chemistry_parameter_id", :limit => 11
    t.integer "instrument_id",                :limit => 11
    t.integer "unit_of_measure_id",           :limit => 11
    t.float   "value"
    t.string  "qualifier"
    t.string  "comment"
  end

  create_table "water_chemistry_samples", :force => true do |t|
    t.integer  "aquatic_activity_event_id", :limit => 11
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
    t.integer  "waterbody_complex_id",    :limit => 11
    t.boolean  "surveyed"
    t.integer  "flows_into_waterbody_id", :limit => 11
    t.datetime "imported_at"
    t.datetime "exported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "waterbodies", ["drainage_code"], :name => "index_waterbodies_on_drainage_code"

end