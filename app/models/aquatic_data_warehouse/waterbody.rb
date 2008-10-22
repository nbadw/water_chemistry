# == Schema Information
# Schema version: 20081008163622
#
# Table name: tblWaterBody
#
#  WaterBodyID            :integer(10)     not null, primary key
#  DrainageCd             :string(17)      
#  WaterBodyTypeCd        :string(4)       
#  WaterBodyName          :string(55)      
#  WaterBodyName_Abrev    :string(40)      
#  WaterBodyName_Alt      :string(40)      
#  WaterBodyComplexID     :integer(5)      
#  Surveyed_Ind           :string(1)       
#  FlowsIntoWaterBodyID   :float(15)       
#  FlowsIntoWaterBodyName :string(40)      
#  FlowIntoDrainageCd     :string(17)      
#  DateEntered            :datetime        
#  DateModified           :datetime        
#  created_at             :datetime        
#  updated_at             :datetime        
#  created_by             :integer(11)     
#  updated_by             :integer(11)     
#

class Waterbody < AquaticDataWarehouse::BaseTbl 
  set_table_name  'tblWaterBody'
  set_primary_key 'WaterBodyID'  
  
  has_many   :aquatic_sites, :foreign_key => primary_key
  belongs_to :drainage_unit, :foreign_key => 'DrainageCd'
  
  def self.search(query)    
    search_conditions = ["#{column_for_attribute(:water_body_name).name} LIKE ? OR #{column_for_attribute(:drainage_cd).name} LIKE ? OR #{primary_key} LIKE ?", "%#{query}%", "#{query}%", "#{query}%"]
    self.find :all, :conditions => search_conditions, :order => "#{column_for_attribute(:water_body_name).name} ASC"
  end
end
