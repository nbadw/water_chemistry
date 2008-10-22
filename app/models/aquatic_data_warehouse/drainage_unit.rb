# == Schema Information
# Schema version: 20081008163622
#
# Table name: tblDraingeUnit
#
#  DrainageCd   :string(17)      not null, primary key
#  Level1No     :string(2)       
#  Level1Name   :string(40)      
#  Level2No     :string(2)       
#  Level2Name   :string(50)      
#  Level3No     :string(2)       
#  Level3Name   :string(50)      
#  Level4No     :string(2)       
#  Level4Name   :string(50)      
#  Level5No     :string(2)       
#  Level5Name   :string(50)      
#  Level6No     :string(2)       
#  Level6Name   :string(50)      
#  UnitName     :string(55)      
#  UnitType     :string(4)       
#  BorderInd    :string(1)       
#  StreamOrder  :integer(5)      
#  Area_ha      :float(15)       
#  Area_percent :float(15)       
#  created_at   :datetime        
#  updated_at   :datetime        
#  created_by   :integer(11)     
#  updated_by   :integer(11)     
#

class DrainageUnit < AquaticDataWarehouse::BaseTbl
  set_table_name  'tblDraingeUnit'
  set_primary_key 'DrainageCd'
  
  has_many :waterbodies, :foreign_key => primary_key
  
  def explain_drainage_code
    (1..6).collect{ |i| self.send("level#{i}_name") }.compact.join(' - ')
  end
end
