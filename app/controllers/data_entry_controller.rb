class DataEntryController < ApplicationController
  layout 'application'
  before_filter :login_required
    
  def browse  
    render :layout => !request.xml_http_request?
  end
  
  def help    
    render :layout => !request.xml_http_request?
  end
  
  def explore    
    @aquatic_sites = AquaticSite.paginate :page => (params[:page] || 1), :per_page => 20, 
      :conditions => ["#{AquaticSite.table_name}.gmap_latitude != 0 AND #{AquaticSite.table_name}.gmap_longitude != 0"], :include => :waterbody
    
    render :template => 'nothing_to_explore' and return if @aquatic_sites.empty?
    
    @site_markers = @aquatic_sites.collect do |aquatic_site|
      if aquatic_site.latitude && aquatic_site.longitude
        { :id => aquatic_site.id, :latitude => aquatic_site.latitude, :longitude => aquatic_site.longitude, 
          :info => render_to_string(:partial => 'aquatic_site/info_window', :locals => { :aquatic_site => aquatic_site }) }
      end
    end.compact    
    
    respond_to do |format|
      format.html { render :layout => !request.xml_http_request? }
      format.js do                 
        render :update do |page|
          page.replace_html('aquatic-sites', :partial => 'aquatic_site/aquatic_sites')
          page << "updateMap(#{@site_markers.to_json});"
        end
      end
    end
  end
end
