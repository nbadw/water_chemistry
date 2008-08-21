# == Schema Information
# Schema version: 2
#
# Table name: cdaquaticactivity
#
#  aquaticactivitycd       :integer(11)     default(0), not null, primary key
#  aquaticactivity         :string(50)      
#  aquaticactivitycategory :string(30)      
#  duration                :string(20)      
#  created_at              :datetime        
#  updated_at              :datetime        
#  imported_at             :datetime        
#  exported_at             :datetime        
#

class AquaticActivity < ActiveRecord::Base  
  set_table_name  :cdaquaticactivity
  set_primary_key :aquaticactivitycd
  
  class << self
    def name_column
      :aquaticactivity
    end
  end
  
  has_many :aquatic_activity_events, :foreign_key => AquaticActivityEvent.aquatic_activity_id_column
  
  alias_attribute :name, :aquaticactivity
  alias_attribute :category, :aquaticactivitycategory
  
  def <=>(compare_to)
    compare_to.is_a?(AquaticActivity) ? self.name <=> compare_to.name : self.name <=> compare_to.to_s
  end
end
