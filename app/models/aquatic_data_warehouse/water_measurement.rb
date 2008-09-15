class WaterMeasurement < AquaticDataWarehouse::BaseTbl
  set_primary_key 'WaterMeasurementID'
  
  belongs_to :oand_m, :foreign_key => 'OandMCd'
  belongs_to :instrument, :foreign_key => 'InstrumentCd'
  belongs_to :unit_of_measure, :foreign_key => 'UnitofMeasureCd'
  belongs_to :sample, :foreign_key => 'SampleID'
end
