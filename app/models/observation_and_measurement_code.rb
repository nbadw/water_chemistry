class ObservationAndMeasurementCode < ActiveRecord::Base
  acts_as_importable 'cdOandM', :prefix => 'OandM'
  import_transformation_for 'OandM_Type', 'o_and_m_type'
end
