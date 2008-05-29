class CdMeasureUnit < ActiveRecord::Base
  set_table_name  'cdMeasureUnit'
  set_primary_key 'measureunitcd'
  acts_as_importable
end
