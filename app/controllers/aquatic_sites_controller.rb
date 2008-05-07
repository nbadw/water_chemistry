class AquaticSitesController < ApplicationController
  def index
    start  = params[:start] || 0
    limit  = params[:limit] || 15   

    options = {
      :select => "*, X(geom) as lng, Y(geom) as lat",
      :offset => start, 
      :limit => limit, 
      :order => 'name ASC'
    }
        
    filter = params[:filter] || ''
    if filter != ''  
      options[:conditions] = [
        "name ILIKE ? OR description ILIKE ?",
        "%#{filter}%",
        "%#{filter}%"
      ]   
    end   
    # geom && SetSRID(E'BOX(-67.925025 45.19194, -66.16489 47.48049)'::box2d, 4326 )
    
    
    @count  = options.has_key?(:conditions) ? 
      AquaticSite.count(:conditions => options[:conditions]) : 
      AquaticSite.count   
    @extent = AquaticSite.connection.select_value("SELECT EXTENT(geom) FROM aquatic_sites")
    @sites  = AquaticSite.find :all, options
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @sites }
      format.js  { render :json => { :results => @count, :sites => @sites } }
    end
  end

  def show
    @site = Site.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site }
    end
  end
end
