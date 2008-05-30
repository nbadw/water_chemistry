class CdAquaticActivityMethod < ActiveRecord::Base
  set_table_name  'cdAquaticActivityMethod'
  set_primary_key 'aquaticmethodcd'
  
  alias_attribute :name, :aquaticmethod
  
  acts_as_importable
end
