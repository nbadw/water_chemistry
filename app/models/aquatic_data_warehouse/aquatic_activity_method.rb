# == Schema Information
# Schema version: 20081127150314
#
# Table name: cdAquaticActivityMethod
#
#  AquaticMethodCd   :integer(5)      not null, primary key
#  AquaticActivityCd :integer(5)      
#  AquaticMethod     :string(30)      
#  created_at        :datetime        
#  updated_at        :datetime        
#  created_by        :integer(11)     
#  updated_by        :integer(11)     
#

class AquaticActivityMethod < AquaticDataWarehouse::BaseCd
  set_primary_key 'AquaticMethodCd'  
  belongs_to :aquatic_activity, :foreign_key => 'AquaticActivityCd'  
  alias_attribute :name, :aquatic_method
end
