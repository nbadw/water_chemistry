class CdUnitOfMeasure < ActiveRecord::Base
  set_table_name  'cdUnitofMeasure'
  set_primary_key 'unitofmeasurecd'
  acts_as_importable
end
