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
