class AquaticActivity < ActiveRecord::Base
  has_many :aquatic_activity_events
  
  def <=>(compare_to)
    compare_to.is_a?(AquaticActivity) ? self.name <=> compare_to.name : self.name <=> compare_to.to_s
  end
end
