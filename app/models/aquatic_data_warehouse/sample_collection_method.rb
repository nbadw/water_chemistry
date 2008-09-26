# == Schema Information
# Schema version: 20080923163956
#
# Table name: cdSampleCollectionMethod
#
#  SampleMethodCd :integer(10)     not null, primary key
#  SampleMethod   :string(30)      
#  Description    :string(255)     
#  created_at     :datetime        
#  updated_at     :datetime        
#  created_by     :integer(11)     
#  updated_by     :integer(11)     
#

class SampleCollectionMethod < AquaticDataWarehouse::BaseCd  
  set_primary_key 'SampleMethodCd'
  
  has_many :samples, :foreign_key => 'SampleCollectionMethodCd'
  
  def name
    sample_method
  end
end
