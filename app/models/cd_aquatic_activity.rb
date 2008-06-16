class CdAquaticActivity < ActiveRecord::Base
  set_table_name  'cdAquaticActivity'
  set_primary_key 'aquaticactivitycd'
  
  alias_attribute :name, :aquaticactivity
  
  has_many :aquatic_activities, :class_name => 'TblAquaticActivity', :foreign_key => 'aquaticactivitycd'
  
  def <=>(compare_to)
    compare_to.is_a?(CdAquaticActivity) ? self.name <=> compare_to.name : self.name <=> compare_to.to_s
  end
end
