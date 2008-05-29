class CdInstrument < ActiveRecord::Base
  set_table_name  'cdInstrument'
  set_primary_key 'instrumentcd'
  acts_as_importable 
end
