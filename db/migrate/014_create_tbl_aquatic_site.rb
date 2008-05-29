class CreateTblAquaticSite < ActiveRecord::Migration
  def self.up
    create_table "tblAquaticSite", :primary_key => "aquaticsiteid" do |t|
      t.integer  "oldaquaticsiteid"
      t.integer  "riversystemid"
      t.integer  "waterbodyid"
      t.string   "waterbodyname",    :limit => 100
      t.string   "aquaticsitename",  :limit => 200
      t.string   "aquaticsitedesc",  :limit => 500
      t.string   "habitatdesc",      :limit => 100
      t.integer  "reachno"
      t.string   "startdesc",        :limit => 200
      t.string   "enddesc",          :limit => 200
      t.float    "startroutemeas"
      t.float    "endroutemeas"
      t.string   "sitetype",         :limit => 40
      t.string   "specificsiteind",  :limit => 2
      t.string   "georeferencedind", :limit => 2
      t.datetime "dateentered"
      t.boolean  "incorporatedind"
      t.string   "coordinatesource", :limit => 100
      t.string   "coordinatesystem", :limit => 100
      t.string   "xcoordinate",      :limit => 100
      t.string   "ycoordinate",      :limit => 100
      t.string   "coordinateunits",  :limit => 100
      t.string   "comments",         :limit => 300
    end
    
    add_index "tblAquaticSite", "riversystemid"
    add_index "tblAquaticSite", "waterbodyid"
  end

  def self.down
    drop_table "tblAquaticSite"
  end
end
