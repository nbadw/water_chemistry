class MeasurementUnitCode < ActiveRecord::Base
  acts_as_importable 'cdMeasureUnit'
  import_transformation_for 'OandMCd', 'observation_and_measurement_code'
end
