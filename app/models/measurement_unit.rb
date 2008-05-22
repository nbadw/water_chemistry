class MeasurementUnit < ActiveRecord::Base
  acts_as_importable 'cdUnitOfMeasure', :column_prefix => 'Instrument'
  import_transformation_for 'UnitofMeasure', 'name'
  import_transformation_for 'UnitofMeasureAbv', 'symbol'
  
  validates_presence_of :name, :symbol
end
