class CreateTblWaterMeasurement < ActiveRecord::Migration
  def self.up
    create_table "tblWaterMeasurement", :primary_key => "watermeasurementid" do |t|
      t.integer "aquaticactivityid"
      t.integer "tempaquaticactivityid"
      t.integer "tempdataid"
      t.integer "temperatureloggerid"
      t.integer "habitatunitid"
      t.integer "sampleid"
      t.string  "watersourcetype",       :limit => 100
      t.float   "waterdepth_m",          :limit => 4
      t.string  "timeofday",             :limit => 10
      t.integer "oandmcd"
      t.integer "instrumentcd"
      t.float   "measurement",           :limit => 4
      t.integer "unitofmeasurecd"
      t.boolean "detectionlimitind",                    :null => false
      t.string  "comment",               :limit => 510
    end
    
    add_index "tblWaterMeasurement", "aquaticactivityid"
    add_index "tblWaterMeasurement", "tempaquaticactivityid"
    add_index "tblWaterMeasurement", "tempdataid"
    add_index "tblWaterMeasurement", "temperatureloggerid"
    add_index "tblWaterMeasurement", "habitatunitid"
    add_index "tblWaterMeasurement", "sampleid"
    add_index "tblWaterMeasurement", "oandmcd"
    add_index "tblWaterMeasurement", "instrumentcd"
    add_index "tblWaterMeasurement", "unitofmeasurecd"
  end

  def self.down
    drop_table "tblWaterMeasurement"
  end
end
