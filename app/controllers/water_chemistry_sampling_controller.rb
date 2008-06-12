class WaterChemistrySamplingController < ApplicationController 
  before_filter :create_aquatic_site_map, :except => [:show, :edit]
  
  def show
    redirect_to :action => 'activity_details', :aquatic_site_id => params[:aquatic_site_id],
      :aquatic_activity_id => params[:aquatic_activity_id]
  end
  
  def edit
    redirect_to :action => 'samples', :aquatic_site_id => params[:aquatic_site_id],
      :aquatic_activity_id => params[:aquatic_activity_id]
  end
  
  def samples   
  end
  
  def activity_details
  end
  
  def observations
  end
  
  private
  def create_aquatic_site_map
    @aquatic_site = TblAquaticSite.find params[:aquatic_site_id], :include => :waterbody
    @aquatic_site_map = GMap.new("aquatic-site-map")
    @aquatic_site_map.set_map_type_init(GMapType::G_HYBRID_MAP)
    @aquatic_site_map.control_init(:small_zoom => true)
    @aquatic_site_map.center_zoom_init([@aquatic_site.latitude, @aquatic_site.longitude], 6)
    @aquatic_site_map.overlay_init(GMarker.new([@aquatic_site.latitude, @aquatic_site.longitude]))
  end
end
