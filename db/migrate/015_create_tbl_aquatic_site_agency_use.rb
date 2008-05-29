class CreateTblAquaticSiteAgencyUse < ActiveRecord::Migration
  def self.up
    create_table "tblAquaticSiteAgencyUse", :primary_key => "aquaticsiteuseid" do |t|
      t.integer "aquaticsiteid"
      t.integer "aquaticactivitycd"
      t.string  "aquaticsitetype",   :limit => 60
      t.string  "agencycd",          :limit => 8
      t.string  "agencysiteid",      :limit => 32
      t.string  "startyear",         :limit => 8
      t.string  "endyear",           :limit => 8
      t.string  "yearsactive",       :limit => 40
      t.boolean "incorporatedind"
    end
    
    add_index "tblAquaticSiteAgencyUse", "aquaticsiteid"
    add_index "tblAquaticSiteAgencyUse", "aquaticactivitycd"
    add_index "tblAquaticSiteAgencyUse", "agencycd"
  end

  def self.down
    drop_table "tblAquaticSiteAgencyUse"
  end
end
