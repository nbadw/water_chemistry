class CdAquaticActivity < ActiveRecord::Base
  set_table_name  'cdAquaticActivity'
  set_primary_key 'aquaticactivitycd'
  
  alias_attribute :name, :aquaticactivity
  
  has_many :aquatic_activities, :class_name => 'TblAquaticActivity', :foreign_key => 'aquaticactivitycd'
  
  acts_as_importable
end
