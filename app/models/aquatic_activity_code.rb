class AquaticActivityCode < ActiveRecord::Base
  has_many :aquatic_activities, :foreign_key => 'aquatic_activity_code'
  
  acts_as_importable 'cdAquaticActivity'
end
