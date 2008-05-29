class CreateTblWaterbody < ActiveRecord::Migration
  def self.up
    create_table "tblWaterBody", :primary_key => "waterbodyid" do |t|
      t.string   "cgndb_key",              :limit => 20
      t.string   "cgndb_key_alt",          :limit => 20
      t.string   "drainagecd",             :limit => 34
      t.string   "waterbodytypecd",        :limit => 8
      t.string   "waterbodyname",          :limit => 110
      t.string   "waterbodyname_abrev",    :limit => 80
      t.string   "waterbodyname_alt",      :limit => 80
      t.integer  "waterbodycomplexid"
      t.string   "surveyed_ind",           :limit => 2
      t.float    "flowsintowaterbodyid"
      t.string   "flowsintowaterbodyname", :limit => 80
      t.string   "flowintodrainagecd",     :limit => 34
      t.datetime "dateentered"
      t.datetime "datemodified"
    end
  end

  def self.down
    drop_table "tblWaterBody"
  end
end
