# == Schema Information
# Schema version: 1
#
# Table name: cdaquaticactivitymethod
#
#  aquaticmethodcd   :integer(11)     not null, primary key
#  aquaticactivitycd :integer(11)     default(0)
#  aquaticmethod     :string(30)      
#  created_at        :datetime        
#  updated_at        :datetime        
#  imported_at       :datetime        
#  exported_at       :datetime        
#

class AquaticActivityMethod < AquaticDataWarehouse::BaseCd
  set_primary_key 'AquaticMethodCd'
  
  belongs_to :aquatic_activity
  
  alias_attribute :name, :aquatic_method
end
