# == Schema Information
# Schema version: 20081008163622
#
# Table name: cdWaterChemistryQualifier
#
#  QualifierCd :string(4)       not null, primary key
#  Qualifier   :string(100)     
#  created_at  :datetime        
#  updated_at  :datetime        
#  created_by  :integer(11)     
#  updated_by  :integer(11)     
#

class Qualifier < AquaticDataWarehouse::BaseCd  
  set_table_name  'cdWaterChemistryQualifier' 
  set_primary_key 'QualifierCd'
  
  alias_attribute :name, :qualifier
end
