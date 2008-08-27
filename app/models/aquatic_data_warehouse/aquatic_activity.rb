# == Schema Information
# Schema version: 1
#
# Table name: cdaquaticactivity
#
#  aquaticactivitycd       :integer(11)     not null, primary key
#  aquaticactivity         :string(50)      
#  aquaticactivitycategory :string(30)      
#  duration                :string(20)      
#  created_at              :datetime        
#  updated_at              :datetime        
#  imported_at             :datetime        
#  exported_at             :datetime        
#

class AquaticActivity < AquaticDataWarehouse::BaseCd  
  has_many :aquatic_activity_events
  
  alias_attribute :name, :aquatic_activity
  alias_attribute :category, :aquatic_activity_category
  
  def <=>(compare_to)
    compare_to.is_a?(AquaticActivity) ? self.name <=> compare_to.name : self.name <=> compare_to.to_s
  end
end
