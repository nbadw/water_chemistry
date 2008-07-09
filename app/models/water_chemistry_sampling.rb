class WaterChemistrySampling
  include Doodle::Core
  
  has :aquatic_site, :kind => AquaticSite
  has :aquatic_activity_event, :kind => AquaticActivityEvent
end
