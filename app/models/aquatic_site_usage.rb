class AquaticSiteUsage < ActiveRecord::Base  
  belongs_to :aquatic_site
  belongs_to :aquatic_activity
  belongs_to :agency
  
  validates_presence_of :aquatic_site, :aquatic_activity, :agency
end
