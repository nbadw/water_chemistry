class WaterChemistrySamplingController < ApplicationController 
  before_filter :create_aquatic_site_map, :except => [:show, :edit]
  
  def show
    redirect_to :action => 'details', :aquatic_site_id => params[:aquatic_site_id],
      :aquatic_activity_event_id => params[:aquatic_activity_event_id]
  end
  
  def edit
    redirect_to :action => 'samples', :aquatic_site_id => params[:aquatic_site_id],
      :aquatic_activity_event_id => params[:aquatic_activity_event_id]
  end
  
  def samples   
  end
  
  def details
  end
  
  def observations
  end
  
  def measurements   
  end
  
  def results    
    samples = WaterChemistrySample.find_all_by_aquatic_activity_event_id params[:aquatic_activity_event_id], :include => [:water_chemistry_sample_results, :water_chemistry_parameters]
    
    @columns = samples.collect{ |sample| sample.water_chemistry_parameters }.flatten.uniq.collect{ |parameter| parameter.code }
    @rows = samples.collect do |sample|
      row = []
      results = sample.water_chemistry_sample_results.to_a
      @columns.each do |column|
        result = results.find { |result| result.water_chemistry_parameter.code == column }
        row << (result ? result.value : nil)
      end
      row
    end    
  end
  
  private  
  def create_aquatic_site_map
    @aquatic_site = AquaticSite.find params[:aquatic_site_id], :include => :waterbody
    @aquatic_site_map = GMap.new("aquatic-site-map")
    @aquatic_site_map.set_map_type_init(GMapType::G_HYBRID_MAP)
    @aquatic_site_map.control_init(:small_zoom => true)
    @aquatic_site_map.center_zoom_init([@aquatic_site.latitude, @aquatic_site.longitude], 6)
    @aquatic_site_map.overlay_init(GMarker.new([@aquatic_site.latitude, @aquatic_site.longitude]))
  end
end
