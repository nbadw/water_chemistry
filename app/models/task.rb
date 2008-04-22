class Task < ActiveRecord::Base
  belongs_to :activity
  
  def url=(value)
    self.write_attribute(:url, value)
  end
end
