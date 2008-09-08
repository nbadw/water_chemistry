class OandM < AquaticDataWarehouse::BaseCd  
  set_primary_key 'OandMCd'
  set_inheritance_column 'OandM_Type'
  
  alias_attribute :name, :oand_m_parameter
  alias_attribute :parameter, :oand_m_parameter
  alias_attribute :category, :oand_m_category
  alias_attribute :group, :oand_m_group
  alias_attribute :values, :oand_m_values_ind
  
  validates_presence_of :oand_m_parameter
  validates_uniqueness_of :oand_m_parameter  
  
  def before_save
    write_attribute('OandM_ValuesInd', false) if oand_m_values_ind.nil?
    return self
  end
end
