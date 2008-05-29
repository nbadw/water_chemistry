class CreateTblSample < ActiveRecord::Migration
  def self.up
    create_table "tblSample", :primary_key => "sampleid" do |t|
      t.integer "aquaticactivityid"
      t.integer "tempaquaticactivityid"
      t.string  "agencysampleno",           :limit => 20
      t.float   "sampledepth_m",            :limit => 4
      t.string  "watersourcetype",          :limit => 40
      t.integer "samplecollectionmethodcd"
      t.string  "analyzedby",               :limit => 510
    end
    add_index "tblSample", "aquaticactivityid"
  end

  def self.down
    drop_table "tblSample"
  end
end
