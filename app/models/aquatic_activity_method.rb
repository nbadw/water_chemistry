class AquaticActivityMethod < ActiveRecord::Base
  alias_attribute :name, :method
  def name
    self.read_attribute(:method)
  end
  
  def name=(val)
    self.write_attribute(:method, val)
  end
end
