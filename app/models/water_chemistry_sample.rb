# == Schema Information
# Schema version: 1
#
# Table name: water_chemistry_samples
#
#  id                        :integer(11)     not null, primary key
#  aquatic_activity_event_id :integer(11)     
#  agency_sample_no          :string(10)      
#  sample_depth_in_m         :float           
#  water_source_type         :string(20)      
#  sample_collection_method  :string(255)     
#  analyzed_by               :string(255)     
#  imported_at               :datetime        
#  exported_at               :datetime        
#  created_at                :datetime        
#  updated_at                :datetime        
#

class WaterChemistrySample < ActiveRecord::Base 
  class << self    
    def sample_collection_methods
      ["Field Kit", "Lab"]
    end
  end
  
  belongs_to :aquatic_activity_event
  has_many   :water_chemistry_sample_results
  has_many   :water_chemistry_parameters, :through => :water_chemistry_sample_results, :uniq => true
  
  validates_inclusion_of :sample_collection_method, :in => self.sample_collection_methods
        
  def to_label
    "Sample Id ##{self.id}"
  end
end
