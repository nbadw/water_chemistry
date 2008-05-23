class EnvironmentalObservation < ActiveRecord::Base
  acts_as_importable 'tblEnvironmentalObservations', :primary_key => 'EnvObservationID'
end
