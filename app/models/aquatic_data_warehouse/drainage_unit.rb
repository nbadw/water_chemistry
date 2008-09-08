# == Schema Information
# Schema version: 1
#
# Table name: cdagency
#
#  id           :integer(11)     not null
#  agencycd     :string(5)       default(""), not null, primary key
#  agency       :string(60)      
#  agencytype   :string(4)       
#  datarulesind :string(1)       default("N")
#  created_at   :datetime        
#  updated_at   :datetime        
#  imported_at  :datetime        
#  exported_at  :datetime        
#

class DrainageUnit < AquaticDataWarehouse::BaseTbl
  set_table_name  'tblDraingeUnit'
  set_primary_key 'DrainageCd'
  
  has_many :waterbodies, :foreign_key => primary_key
end
