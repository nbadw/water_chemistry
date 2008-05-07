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
    t.column "name", :string, :default => "", :null => false
    t.column "desc", :text
    t.column "category", :string, :default => "", :null => false
    t.column "duration", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "agencies", :force => true do |t|
    t.column "name", :string
    t.column "agency_type", :string
    t.column "data_rules", :boolean
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "aquatic_site_usages", :force => true do |t|
    t.column "aquatic_site_id", :integer
    t.column "aquatic_activity_code", :integer
    t.column "aquatic_site_type", :string
    t.column "agency_code", :string
    t.column "agency_site_id", :string
    t.column "start_year", :string
    t.column "end_year", :string
    t.column "years_active", :string
    t.column "incorporated_at", :datetime
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "aquatic_sites", :force => true do |t|
    t.column "old_aquatic_site_id", :integer
    t.column "river_system_id", :integer
    t.column "waterbody_id", :integer
    t.column "name", :string
    t.column "description", :string
    t.column "habitat_desc", :string
    t.column "reach_no", :integer
    t.column "start_desc", :string
    t.column "end_desc", :string
    t.column "start_route_meas", :float
    t.column "end_route_meas", :float
    t.column "site_type", :string
    t.column "specific_site", :boolean
    t.column "georeferenced", :boolean
    t.column "entered_at", :datetime
    t.column "incorporated_at", :datetime
    t.column "coordinate_source", :string
    t.column "coordinate_system", :string
    t.column "coordinate_units", :string
    t.column "x_coord", :string
    t.column "y_coord", :string
    t.column "comments", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "deleted_at", :datetime
  end

  create_table "permissions", :force => true do |t|
    t.column "role_id", :integer, :null => false
    t.column "user_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "roles", :force => true do |t|
    t.column "rolename", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "users", :force => true do |t|
    t.column "login", :string
    t.column "email", :string
    t.column "crypted_password", :string, :limit => 40
    t.column "salt", :string, :limit => 40
    t.column "remember_token", :string
    t.column "remember_token_expires_at", :datetime
    t.column "activation_code", :string, :limit => 40
    t.column "activated_at", :datetime
    t.column "password_reset_code", :string, :limit => 40
    t.column "enabled", :boolean, :default => true
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "agency_id", :integer
  end

  create_table "waterbodies", :force => true do |t|
    t.column "name", :string
    t.column "abbrev_name", :string
    t.column "alt_name", :string
    t.column "drainage_code", :string
    t.column "waterbody_type", :string
    t.column "waterbody_complex_id", :integer
    t.column "surveyed", :boolean
    t.column "flows_into_waterbody_id", :integer
    t.column "flows_into_waterbody_name", :string
    t.column "flows_into_watershed", :string
    t.column "date_entered", :datetime
    t.column "date_modified", :datetime
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "watersheds", :force => true do |t|
    t.column "name", :string
    t.column "unit_type", :string
    t.column "border", :boolean
    t.column "stream_order", :integer
    t.column "area_ha", :float
    t.column "area_percent", :float
    t.column "drains_into", :string
    t.column "level1_no", :string
    t.column "level1_name", :string
    t.column "level2_no", :string
    t.column "level2_name", :string
    t.column "level3_no", :string
    t.column "level3_name", :string
    t.column "level4_no", :string
    t.column "level4_name", :string
    t.column "level5_no", :string
    t.column "level5_name", :string
    t.column "level6_no", :string
    t.column "level6_name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

end
