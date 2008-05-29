class CreateTblAquaticActivity < ActiveRecord::Migration
  def self.up
    create_table "tblAquaticActivity", :primary_key => "aquaticactivityid" do |t|
      t.integer  "tempaquaticactivityid"
      t.string   "project",                  :limit => 200
      t.string   "permitno",                 :limit => 40
      t.integer  "aquaticprogramid"
      t.integer  "aquaticactivitycd"
      t.integer  "aquaticmethodcd"
      t.integer  "oldaquaticsiteid"
      t.integer  "aquaticsiteid"
      t.string   "aquaticactivitystartdate", :limit => 20
      t.string   "aquaticactivityenddate",   :limit => 20
      t.string   "aquaticactivitystarttime", :limit => 12
      t.string   "aquaticactivityendtime",   :limit => 12
      t.string   "year",                     :limit => 8
      t.string   "agencycd",                 :limit => 8
      t.string   "agency2cd",                :limit => 8
      t.string   "agency2contact",           :limit => 100
      t.string   "aquaticactivityleader",    :limit => 100
      t.string   "crew",                     :limit => 100
      t.string   "weatherconditions",        :limit => 100
      t.float    "watertemp_c",              :limit => 4
      t.float    "airtemp_c",                :limit => 4
      t.string   "waterlevel",               :limit => 12
      t.string   "waterlevel_cm",            :limit => 100
      t.string   "waterlevel_am_cm",         :limit => 100
      t.string   "waterlevel_pm_cm",         :limit => 100
      t.string   "siltation",                :limit => 100
      t.boolean  "primaryactivityind"
      t.string   "comments",                 :limit => 500
      t.datetime "dateentered"
      t.boolean  "incorporatedind"
      t.datetime "datetransferred"
    end
    
    add_index "tblAquaticActivity", "aquaticprogramid"    
    add_index "tblAquaticActivity", "aquaticactivitycd"
    add_index "tblAquaticActivity", "aquaticmethodcd"
    add_index "tblAquaticActivity", "oldaquaticsiteid"
    add_index "tblAquaticActivity", "aquaticsiteid"
    add_index "tblAquaticActivity", "agencycd"
    add_index "tblAquaticActivity", "agency2cd"
  end

  def self.down
    drop_table "tblAquaticActivity"
  end
end
