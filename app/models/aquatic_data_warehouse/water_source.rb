class WaterSource < AquaticDataWarehouse::BaseCd  
  set_primary_key 'WaterSourceCd'
  
  alias_attribute :name, :water_source
end
