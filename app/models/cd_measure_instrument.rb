class CdMeasureInstrument < ActiveRecord::Base
  set_table_name  'cdMeasureInstrument'
  set_primary_key 'measureinstrumentcd'
  acts_as_importable
end
