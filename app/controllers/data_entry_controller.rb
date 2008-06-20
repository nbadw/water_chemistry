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
    @aquatic_sites = TblAquaticSite.paginate :page => (params[:page] || 1), :per_page => 20, 
      :conditions => ["#{TblAquaticSite.table_name}.wgs84_lat != 0 AND #{TblAquaticSite.table_name}.wgs84_lon != 0"], :include => :waterbody
    @site_markers = @aquatic_sites.collect do |aquatic_site|
      if aquatic_site.latitude && aquatic_site.longitude
        { :id => aquatic_site.id, :latitude => aquatic_site.latitude, :longitude => aquatic_site.longitude, 
          :info => render_to_string(:partial => 'tbl_aquatic_site/info_window', :locals => { :aquatic_site => aquatic_site }) }
      end
    end.compact    
    
    respond_to do |format|
      format.html { render :layout => !request.xml_http_request? }
      format.js do                 
        render :update do |page|
          page.replace_html('aquatic-sites', :partial => 'tbl_aquatic_site/aquatic_sites')
          page << "updateMap(#{@site_markers.to_json});"
        end
      end
    end
  end
end
