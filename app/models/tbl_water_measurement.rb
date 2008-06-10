class TblWaterMeasurement < ActiveRecord::Base
  set_table_name  'tblWaterMeasurement'
  set_primary_key 'watermeasurementid'
  
  alias_attribute :water_source_type, :watersourcetype
  alias_attribute :water_depth_in_meters, :waterdepth_m
  alias_attribute :detection_limit, :detectionlimitind
  
  belongs_to :aquatic_activity, :class_name => 'TblAquaticActivity', :foreign_key => 'aquaticactivityid'
  belongs_to :sample, :class_name => 'TblSample', :foreign_key => 'sampleid'
#    t.integer "tempdataid"
#    t.integer "temperatureloggerid"
#    t.integer "habitatunitid"
#    t.string  "watersourcetype",       :limit => 100
#    t.float   "waterdepth_m",          :limit => 4
#    t.string  "timeofday",             :limit => 10
#    t.integer "oandmcd"
#    t.integer "instrumentcd"
#    t.float   "measurement",           :limit => 4
#    t.integer "unitofmeasurecd"
#    t.boolean "detectionlimitind",                    :null => false
#    t.string  "comment",               :limit => 510
  
  acts_as_importable  
  
end
