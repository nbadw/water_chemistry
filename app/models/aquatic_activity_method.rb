class AquaticActivityMethod < ActiveRecord::Base  
  set_table_name  :cdaquaticactivitymethod
  set_primary_key :aquaticmethodcd
  
  belongs_to :aquatic_activity
  
  alias_attribute :method, :aquaticmethod
  alias_attribute :name, :aquaticmethod
  alias_attribute :aquatic_activity_id, :aquaticactivitycd  

#  class << self
#    def find
#  end
end
