class CdOAndMValues < ActiveRecord::Base
  set_table_name  'cdOandMValues'
  set_primary_key 'oandmvaluescd'
  acts_as_importable
end
