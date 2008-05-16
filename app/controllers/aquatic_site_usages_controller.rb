class AquaticSiteUsagesController < ApplicationController
  layout 'admin'
  active_scaffold :aquatic_site_usage do |config|
    config.columns = [:aquatic_site, :agency, :agency_site_id, 
      :activity
    ]
  end
  
  def site_activity_usages    
    @aquatic_site_id = params[:aquatic_site_id]
    @activity_id = params[:activity_id]
    @label = params[:label]
    render :layout => false
  end
end
