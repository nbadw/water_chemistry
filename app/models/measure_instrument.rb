class MeasureInstrument < ActiveRecord::Base
  acts_as_importable 'cdMeasureInstrument'
  import_transformation_for 'OandMCd', 'observation_and_measurement_code'
end
