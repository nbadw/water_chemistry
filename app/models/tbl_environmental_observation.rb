class TblEnvironmentalObservation < ActiveRecord::Base
  set_table_name  'tblEnvironmentalObservations'
  set_primary_key 'envobservationid'
  acts_as_importable
end
