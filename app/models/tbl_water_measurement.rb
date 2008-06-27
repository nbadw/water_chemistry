class TblWaterMeasurement < ActiveRecord::Base
  set_table_name  'tblWaterMeasurement'
  set_primary_key 'watermeasurementid'
  
  alias_attribute :water_source_type, :watersourcetype
  alias_attribute :water_depth_in_meters, :waterdepth_m
  alias_attribute :detection_limit, :detectionlimitind
  
  belongs_to :aquatic_activity, :foreign_key => 'aquaticactivityid'
  belongs_to :sample, :class_name => 'TblSample', :foreign_key => 'sampleid' 
end
