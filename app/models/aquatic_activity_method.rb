class AquaticActivityMethod < ActiveRecord::Base
  def name
    self.read_attribute(:method)
  end
  
  def name=(val)
    self.write_attribute(:method, val)
  end
end
