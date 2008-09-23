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
  
  def details    
  end
  
  def samples   
  end
    
  def observations
  end
  
  def measurements   
  end
  
  def results    
    samples = Sample.for_aquatic_activity_event(params[:aquatic_activity_event_id])    
    
    @columns = samples.collect{ |sample| sample.sample_results }.flatten.uniq.collect{ |result| result.chemical.parameter_cd }
    @rows = samples.collect do |sample|
      row = []
      results = sample.sample_results.to_a
      @columns.each do |column|
        result = results.find { |result| result.chemical.parameter_cd == column }
        row << (result ? "#{result.measurement} #{result.qualifier.id if result.qualifier}".strip : nil)
      end
      row
    end  
    @qualifiers = samples.collect { |sample| sample.sample_results.collect { |water_meas| water_meas.qualifier } }.flatten.compact.uniq    
  end
  
  private  
  def create_aquatic_site_map
    @aquatic_site = AquaticSite.find params[:aquatic_site_id], :include => :waterbody
    #@aquatic_site_map = GMap.new("aquatic-site-map")
    #@aquatic_site_map.set_map_type_init(GMapType::G_HYBRID_MAP)
    #@aquatic_site_map.control_init(:small_zoom => true)
    #@aquatic_site_map.center_zoom_init([@aquatic_site.gmap_location.latitude, @aquatic_site.gmap_location.longitude], 6)
    #@aquatic_site_map.overlay_init(GMarker.new([@aquatic_site.gmap_location.latitude, @aquatic_site.gmap_location.longitude]))
  end
end
