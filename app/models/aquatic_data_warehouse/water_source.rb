# == Schema Information
# Schema version: 20080923163956
#
# Table name: cdWaterSource
#
#  WaterSourceCd   :string(4)       not null, primary key
#  WaterSource     :string(20)      
#  WaterSourceType :string(20)      
#  created_at      :datetime        
#  updated_at      :datetime        
#  created_by      :integer(11)     
#  updated_by      :integer(11)     
#

class WaterSource < AquaticDataWarehouse::BaseCd  
  set_primary_key 'WaterSourceCd'
  
  alias_attribute :name, :water_source
end
