class TblSample < ActiveRecord::Base
  set_table_name  'tblSample'
  set_primary_key 'sampleid'
  
  alias_attribute :agency_sample_no, :agencysampleno
  alias_attribute :sample_depth_in_meters, :sampledepth_m
  alias_attribute :water_source_type, :watersourcetype
  alias_attribute :analyzed_by, :analyzedby
  alias_attribute :collection_method, :samplecollectionmethodcd
  
  def self.collection_method_options
    ["Field Kit", "Lab"]
  end
  
  belongs_to :aquatic_activity, :class_name => 'TblAquaticActivity', :foreign_key => 'aquaticactivityid'
  has_many :results, :class_name => 'TblWaterMeasurement', :foreign_key => 'sampleid'
  
  validates_inclusion_of :collection_method, :in => self.collection_method_options
        
  def to_label
    "Sample Id:#{self.id}"
  end
end
