class SiteObservation < ActiveRecord::Base
  belongs_to :aquatic_site
  belongs_to :aquatic_activity_event
  belongs_to :observation
  
  validates_presence_of :aquatic_site, :aquatic_activity_event, :observation
end
