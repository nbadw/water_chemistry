class CdAquaticActivity < ActiveRecord::Base
  set_table_name  'cdAquaticActivity'
  set_primary_key 'aquaticactivitycd'
  
  acts_as_importable
end
