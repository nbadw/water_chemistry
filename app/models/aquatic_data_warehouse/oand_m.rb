# == Schema Information
# Schema version: 20081008163622
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
#  created_at        :datetime        
#  updated_at        :datetime        
#  created_by        :integer(11)     
#  updated_by        :integer(11)     
#

class OandM < AquaticDataWarehouse::BaseCd  
  set_primary_key 'OandMCd'
  set_inheritance_column 'OandM_Type'
  
  alias_attribute :name, :oand_m_parameter
  alias_attribute :parameter, :oand_m_parameter
  alias_attribute :category, :oand_m_category
  alias_attribute :group, :oand_m_group
  alias_attribute :values, :oand_m_values_ind
  alias_attribute :parameter_cd, :oand_m_parameter_cd
  
  validates_presence_of   :oand_m_parameter
  validates_uniqueness_of :oand_m_parameter  
end
