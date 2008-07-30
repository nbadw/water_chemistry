class AquaticActivity < ActiveRecord::Base
  set_table_name  :cdaquaticactivity
  set_primary_key :aquaticactivitycd
  
  has_many :aquatic_activity_events
  
  alias_attribute :name, :aquaticactivity
  alias_attribute :category, :aquaticactivitycategory
  
  def <=>(compare_to)
    compare_to.is_a?(AquaticActivity) ? self.name <=> compare_to.name : self.name <=> compare_to.to_s
  end
end
