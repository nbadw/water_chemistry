class TblSample < ActiveRecord::Base
  set_table_name  'tblSample'
  set_primary_key 'sampleid'
  
  alias_attribute :agency_sample_no, :agencysampleno
  alias_attribute :sample_depth_in_meters, :sampledepth_m
  alias_attribute :water_source_type, :watersourcetype
  alias_attribute :analyzed_by, :analyzedby
  
  #belongs_to :sample_collection_method, :class_name => '', :foreign_key => 'samplecollectionmethodcd'
  belongs_to :aquatic_activity, :class_name => 'TblAquaticActivity', :foreign_key => 'aquaticactivityid'
  has_many :water_measurements, :class_name => 'TblWaterMeasurement', :foreign_key => 'sampleid'
  
  acts_as_importable 
end
