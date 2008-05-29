class CdOAndM < ActiveRecord::Base
  set_table_name  'cdOandM'
  set_primary_key 'oandmcd'
  acts_as_importable
end
