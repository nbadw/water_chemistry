class OandM < AquaticDataWarehouse::BaseCd  
  set_primary_key 'OandMCd'
  set_inheritance_column 'OandM_Type'
  
  alias_attribute :category, :oand_m_category
  alias_attribute :group, :oand_m_group
  alias_attribute :parameter, :oand_m_parameter
  alias_attribute :values, :oand_m_values_ind
end
