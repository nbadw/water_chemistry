class TblObservation < ActiveRecord::Base
  set_table_name  'tblObservations'
  set_primary_key 'observationid'
  
  belongs_to :aquatic_activity, :class_name => 'TblAquaticActivity', :foreign_key => 'aquaticactivityid'
  belongs_to :observation_code, :class_name => 'CdOAndM', :foreign_key => 'oandmcd'
end
