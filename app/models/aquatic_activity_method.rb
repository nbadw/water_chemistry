# == Schema Information
# Schema version: 2
#
# Table name: cdaquaticactivitymethod
#
#  aquaticmethodcd   :integer(11)     default(0), not null, primary key
#  aquaticactivitycd :integer(11)     default(0)
#  aquaticmethod     :string(30)      
#  created_at        :datetime        
#  updated_at        :datetime        
#  imported_at       :datetime        
#  exported_at       :datetime        
#

class AquaticActivityMethod < ActiveRecord::Base  
  set_table_name  :cdaquaticactivitymethod
  set_primary_key :aquaticmethodcd
  
  belongs_to :aquatic_activity
  
  alias_attribute :method, :aquaticmethod
  alias_attribute :name, :aquaticmethod
  alias_attribute :aquatic_activity_id, :aquaticactivitycd  

  class << self
    def aquatic_activity_column
      :aquaticactivitycd
    end
  end
end
