class SampleCollectionMethod < AquaticDataWarehouse::BaseCd  
  set_primary_key 'SampleMethodCd'
  
  has_many :samples, :foreign_key => 'SampleCollectionMethodCd'
  
  def name
    sample_method
  end
end
