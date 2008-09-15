class Sample < AquaticDataWarehouse::BaseTbl
  set_primary_key 'SampleID'
  
  belongs_to :aquatic_activity, :foreign_key => 'AquaticActivityID'
  belongs_to :sample_collection_method, :foreign_key => 'SampleCollectionMethodCd'
  has_many   :sample_results, :class_name => 'WaterMeasurement', :foreign_key => 'SampleID'
end
