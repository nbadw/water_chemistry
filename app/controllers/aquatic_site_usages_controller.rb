class AquaticSiteUsagesController < ApplicationController
  layout 'admin'
  active_scaffold :aquatic_site_usage do |config|
    config.columns = [:aquatic_site, :description, :agency, :agency_site_id, 
      :waterbody_id, :waterbody_name, :activity
    ]
  end
end
