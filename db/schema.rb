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

ActiveRecord::Schema.define(:version => 8) do

  create_table "activities", :force => true do |t|
    t.column "name", :string, :null => false
    t.column "title", :string, :null => false
    t.column "desc", :text
    t.column "author", :string
    t.column "type", :string
    t.column "agency_id", :integer, :null => false
    t.column "version", :integer
    t.column "deleted_at", :timestamp
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "geom", :geometry, :srid => 4326
  end

  add_index "activities", ["geom"], :name => "index_activities_on_geom", :spatial=> true 

  create_table "activity_versions", :force => true do |t|
    t.column "activity_id", :integer
    t.column "version", :integer
    t.column "name", :string
    t.column "title", :string
    t.column "desc", :text
    t.column "author", :string
    t.column "agency_id", :integer
    t.column "deleted_at", :timestamp
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "geom", :geometry
    t.column "versioned_type", :string
  end

  create_table "agencies", :force => true do |t|
    t.column "name", :string
    t.column "code", :string
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  create_table "aquatic_sites", :force => true do |t|
    t.column "name", :string
    t.column "description", :string
    t.column "waterbody_id", :integer
    t.column "drainage_code", :string
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "geom", :point, :srid => 4326, :null => false
  end

  add_index "aquatic_sites", ["geom"], :name => "index_aquatic_sites_on_geom", :spatial=> true 

  create_table "permissions", :force => true do |t|
    t.column "role_id", :integer, :null => false
    t.column "user_id", :integer, :null => false
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  create_table "roles", :force => true do |t|
    t.column "rolename", :string
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  create_table "tasks", :force => true do |t|
    t.column "title", :string, :null => false
    t.column "position", :integer, :null => false
    t.column "activity_id", :integer, :null => false
    t.column "controller", :string, :null => false
    t.column "action", :string, :null => false
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  create_table "users", :force => true do |t|
    t.column "login", :string
    t.column "email", :string
    t.column "crypted_password", :string, :limit => 40
    t.column "salt", :string, :limit => 40
    t.column "remember_token", :string
    t.column "remember_token_expires_at", :timestamp
    t.column "activation_code", :string, :limit => 40
    t.column "activated_at", :timestamp
    t.column "password_reset_code", :string, :limit => 40
    t.column "enabled", :boolean, :default => true
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

end
