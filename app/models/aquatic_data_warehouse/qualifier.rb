class Qualifier < AquaticDataWarehouse::BaseCd  
  set_table_name  'cdWaterChemistryQualifier' 
  set_primary_key 'QualifierCd'
  
  alias_attribute :name, :qualifier
end
