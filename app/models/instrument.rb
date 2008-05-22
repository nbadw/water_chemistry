class Instrument < ActiveRecord::Base
  acts_as_importable 'cdInstrument', :primary_key => 'InstrumentCd', :column_prefix => 'Instrument'
  validates_presence_of :name
  
  import_transformation_for 'Instrument', 'name'
end
