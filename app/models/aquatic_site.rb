class AquaticSite < ActiveRecord::Base
  acts_as_paranoid  
  
  has_many :activity_events, :dependent => :destroy
  has_many :activities, :through => :activity_events  
  belongs_to :waterbody
  
  validates_presence_of :geom
  
  def lat
    self.latitude
  end
  
  def latitude
    self.geom ? self.geom.lat : nil
  end
  
  def lon
    self.longitude
  end
  
  def longitude
    self.geom ? self.geom.lon : nil
  end
end
