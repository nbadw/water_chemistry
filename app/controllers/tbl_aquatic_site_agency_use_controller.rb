class TblAquaticSiteAgencyUseController < ApplicationController  
  active_scaffold do |config|
    config.create.label = ''
    config.create.columns = [:aquatic_activity_code, :agencysiteid]
    config.columns[:aquatic_activity_code].label = "Select a Data Set to Add"
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
    record.agencycd = current_user.agency.code
    record.aquaticsiteid = params[:aquatic_site_id]
  end
end
