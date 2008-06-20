class TblSiteMeasurement < ActiveRecord::Base
  set_table_name  "tblSiteMeasurement"
  set_primary_key "sitemeasurementid"
  
  belongs_to :aquatic_activity, :class_name => 'TblAquaticActivity', :foreign_key => 'aquaticactivityid'
  belongs_to :measurement_code, :class_name => 'CdOAndM', :foreign_key => 'oandmcd'
  
  validates_presence_of :measurement, :aquatic_activity, :measurement_code
end
