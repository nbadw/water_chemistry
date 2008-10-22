# == Schema Information
# Schema version: 20081008163622
#
# Table name: tblSample
#
#  SampleID                 :integer(10)     not null, primary key
#  AquaticActivityID        :integer(10)     
#  TempAquaticActivityID    :integer(10)     
#  LabNo                    :string(10)      
#  AgencySampleNo           :string(10)      
#  SampleDepth_m            :float(7)        
#  WaterSourceType          :string(20)      
#  SampleCollectionMethodCd :integer(10)     
#  AnalyzedBy               :string(255)     
#  created_at               :datetime        
#  updated_at               :datetime        
#  created_by               :integer(11)     
#  updated_by               :integer(11)     
#

class Sample < AquaticDataWarehouse::BaseTbl
  set_primary_key 'SampleID'
  
  belongs_to :aquatic_activity_event, :foreign_key => 'AquaticActivityID'
  belongs_to :sample_collection_method, :foreign_key => 'SampleCollectionMethodCd'
  has_many   :sample_results, :class_name => 'WaterMeasurement', :foreign_key => 'SampleID'
  
  def to_label
    "Sample ##{id}"
  end
  
  named_scope :for_aquatic_activity_event, lambda { |id| { :conditions => ['AquaticActivityID = ?', id], :include => [:sample_results] } }  
end
