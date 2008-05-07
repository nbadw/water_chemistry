class AquaticSiteUsagesController < ApplicationController
  layout 'admin'
  active_scaffold :aquatic_site_usage do |config|
    config.columns = [:aquatic_site, :agency, :agency_site_id, 
      :waterbody_id, :waterbody_name, :description
    ]
  end
end
