class WaterChemistrySample < ActiveRecord::Base  
#  alias_attribute :agency_sample_no, :agencysampleno
#  alias_attribute :sample_depth_in_meters, :sampledepth_m
#  alias_attribute :water_source_type, :watersourcetype
#  alias_attribute :analyzed_by, :analyzedby
#  alias_attribute :collection_method, :samplecollectionmethodcd
#  
#  def self.collection_method_options
#    ["Field Kit", "Lab"]
#  end
#  
#  belongs_to :aquatic_activity, :foreign_key => 'aquaticactivityid'
#  has_many   :sample_results, :foreign_key => 'sample_id'
#  has_many   :parameters, :through => :sample_results, :uniq => true
#  
#  validates_inclusion_of :collection_method, :in => self.collection_method_options
#        
#  def to_label
#    "Sample Id ##{self.id}"
#  end
end
