class UnitOfMeasureCode < ActiveRecord::Base
  acts_as_importable 'cdUnitofMeasure'
  import_transformation_for 'UnitofMeasureAbv', 'unit_of_measure_abbreviation'
end
