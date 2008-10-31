class WaterChemistrySamplingController < ApplicationController 
  before_filter :login_required
  before_filter :create_aquatic_site_map, :except => [:show, :edit]
    
  def edit
    redirect_to :action => 'samples', :aquatic_site_id => params[:aquatic_site_id],
      :aquatic_activity_event_id => params[:aquatic_activity_event_id]
  end
    
  def samples   
  end
    
  def observations
  end
  
  def measurements   
  end
  
  def report  
    options = {
      :report_on => { 
        :aquatic_site => AquaticSite.find(params[:aquatic_site_id]),
        :aquatic_activity_event => AquaticActivityEvent.find(params[:aquatic_activity_event_id])
      },      
      :agency => current_user.agency
    }
    
    respond_to do |wants|
      wants.html { @report_html =  Reports::WaterChemistrySampling.render_html(options) }
      wants.csv do        
        csv = Reports::WaterChemistrySampling.render_csv(options)  
        send_data csv, :type => "text/csv", :filename => "water_chemistry_sampling_report.csv" 
      end
    end 
  end
  
  private  
  def create_aquatic_site_map
    @aquatic_site = AquaticSite.find params[:aquatic_site_id], :include => [:waterbody, :gmap_location]
    
    return unless @aquatic_site.gmap_location
    
    @aquatic_site_map = GMap.new("aquatic-site-map")
    @aquatic_site_map.set_map_type_init(GMapType::G_HYBRID_MAP)
    @aquatic_site_map.control_init(:small_zoom => true)
    @aquatic_site_map.center_zoom_init([@aquatic_site.gmap_location.latitude, @aquatic_site.gmap_location.longitude], 6)
    @aquatic_site_map.overlay_init(GMarker.new([@aquatic_site.gmap_location.latitude, @aquatic_site.gmap_location.longitude]))
  end
end
