# == Schema Information
# Schema version: 1
#
# Table name: cdSampleCollectionMethod
#
#  SampleMethodCd :integer(10)     not null, primary key
#  SampleMethod   :string(30)      
#  Description    :string(255)     
#

class SampleCollectionMethod < AquaticDataWarehouse::BaseCd  
  set_primary_key 'SampleMethodCd'
  
  has_many :samples, :foreign_key => 'SampleCollectionMethodCd'
  
  def name
    sample_method
  end
end
