class AquaticSiteUsageController < ApplicationController  
  active_scaffold do |config|
    config.create.label = ''
    config.create.columns = [:aquatic_activity_id, :agency_site_id]
    config.columns[:aquatic_activity_id].label = "Select a Data Set to Add"
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
  
  def before_create_save(record)
    record.agency_id = current_user.agency.id
    record.aquatic_site_id = params[:aquatic_site_id]
  end
end
