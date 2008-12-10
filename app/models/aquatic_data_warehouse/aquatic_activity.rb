# == Schema Information
# Schema version: 20081127150314
#
# Table name: cdAquaticActivity
#
#  AquaticActivityCd       :integer(5)      not null, primary key
#  AquaticActivity         :string(50)      
#  AquaticActivityCategory :string(30)      
#  Duration                :string(20)      
#  created_at              :datetime        
#  updated_at              :datetime        
#  created_by              :integer(11)     
#  updated_by              :integer(11)     
#

class AquaticActivity < AquaticDataWarehouse::BaseCd 
  set_primary_key 'AquaticActivityCd'
  
  has_many :aquatic_activity_events, :foreign_key => 'AquaticActivityID'
  
  alias_attribute :name, :aquatic_activity
  alias_attribute :category, :aquatic_activity_category
  
  def <=>(compare_to)
    compare_to.is_a?(AquaticActivity) ? self.name <=> compare_to.name : self.name <=> compare_to.to_s
  end
end
