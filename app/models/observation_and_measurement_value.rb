class ObservationAndMeasurementValue < ActiveRecord::Base
  acts_as_importable 'cdOandMValues'
  import_transformation_for 'OandMCd', 'observation_and_measurement_code'
  import_transformation_for 'Value', 'value'
end
