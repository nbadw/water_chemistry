class DataEntryController < ApplicationController
  before_filter :login_required
    
  def browse  
  end
  
  def help    
    render :layout => !request.xml_http_request?
  end
  
  def explore 
    water_chemistry_activity_id = 17
    aquatic_sites = AquaticSite.all(
      :conditions => [
        "#{AquaticSiteUsage.table_name}.AquaticActivityCd = ?",
        water_chemistry_activity_id
      ], 
      :include => [:aquatic_site_usages, :waterbody, :gmap_location]
    ).collect do |site|
      count = AquaticActivityEvent.count_attached(site, water_chemistry_activity_id) 
      location = site.gmap_location
      valid = count != 0 && (location && location.latitude && location.longitude)      
      site if valid
    end.compact
    
    @site_markers = aquatic_sites.uniq.collect do |aquatic_site|
      { :id => aquatic_site.id, 
        :latitude => aquatic_site.gmap_location.latitude, 
        :longitude => aquatic_site.gmap_location.longitude, 
        :info => render_to_string(
          :partial => 'data_collection_sites/info_window', 
          :locals => { :aquatic_site => aquatic_site }
        )          
      }
    end 

    render :layout => 'explore'
  end
end
