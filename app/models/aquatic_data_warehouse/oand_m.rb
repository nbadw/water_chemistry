# == Schema Information
# Schema version: 1
#
# Table name: cdOandM
#
#  OandMCd           :integer(10)     not null, primary key
#  OandM_Type        :string(16)      
#  OandM_Category    :string(40)      
#  OandM_Group       :string(50)      
#  OandM_Parameter   :string(50)      
#  OandM_ParameterCd :string(30)      
#  OandM_ValuesInd   :boolean(1)      not null
#  OandM_DetailsInd  :boolean(1)      not null
#  FishPassageInd    :boolean(1)      not null
#  BankInd           :boolean(1)      not null
#

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
    write_attribute('OandM_ValuesInd', false)  if oand_m_values_ind.nil?
    write_attribute('FishPassageInd', false)   if fish_passage_ind.nil?
    write_attribute('BankInd', false)          if bank_ind.nil?
    write_attribute('OandM_DetailsInd', false) if oand_m_details_ind.nil?
    return self
  end
end
