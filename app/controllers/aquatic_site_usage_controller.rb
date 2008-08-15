class AquaticSiteUsageController < ApplicationController  
  active_scaffold do |config|
    config.create.label = ''
    config.create.columns = [:aquatic_activity_id, :agency_site_id]
    config.columns[:aquatic_activity_id].label = "Select a Data Set to Add"
    config.columns[:agency_site_id].label = "Agency Site ID"
  end
  
  def authorized_for_read?
    false
  end
  
  def authorized_for_destroy?
    false 
  end
  
  def authorized_for_update?
    false
  end
  
  def before_create_save(aquatic_site_usage)
    aquatic_site_usage.agency_id = current_user.agency.id
    aquatic_site_usage.aquatic_site_id = params[:aquatic_site_id]
  end
end
