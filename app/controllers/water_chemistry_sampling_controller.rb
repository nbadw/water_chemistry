class WaterChemistrySamplingController < ApplicationController 
  before_filter :login_required
  before_filter :create_aquatic_site_map, :except => [:show, :edit]
  before_filter :check_for_legacy_samples, :only => :samples
  layout 'application'
  
  def current_location
    :water_chemistry_sampling_current_location.l
  end
  
  def previous_location    
    :water_chemistry_sampling_previous_location.l
  end

  def uses_gmap?
    @aquatic_site_map
  end
        
  def samples  
  end
    
  def observations
  end
  
  def measurements
    include_javascript 'water_chemistry_sampling_measurements', :lazy_load => true
  end
  
  def report  
    include_stylesheet 'water_chemistry_report'
    include_stylesheet 'print', :media => :print
    
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
        send_data csv, :type => "text/csv", :filename => :report_filename.l("water_chemistry_sampling_report.csv")
      end
    end 
  end
  
  private
  def check_for_legacy_samples
    water_chemistry_sampling_activity_id = 17
    query = %Q{
      SELECT
        COUNT(`tblAquaticActivity`.`AquaticActivityID`) AS sampling_events,
        COUNT(`tblAquaticActivity`.`created_at`) AS sampling_events_with_created_at_timestamp,
        `cdAgency`.`Agency` AS agency
      FROM `tblAquaticSite`
        LEFT OUTER JOIN `tblAquaticSiteAgencyUse` ON `tblAquaticSiteAgencyUse`.`AquaticSiteID` = `tblAquaticSite`.`AquaticSiteID`
        LEFT OUTER JOIN `tblAquaticActivity` ON `tblAquaticActivity`.`AquaticSiteID` = `tblAquaticSite`.`AquaticSiteID`
        LEFT OUTER JOIN `tblSample` ON `tblSample`.`AquaticActivityID` = `tblAquaticActivity`.`AquaticActivityID`
        LEFT OUTER JOIN `cdAgency` ON `cdAgency`.`AgencyCd` = `tblAquaticSiteAgencyUse`.`AgencyCd`
      WHERE (
        `tblAquaticSite`.`AquaticSiteID` = #{params[:aquatic_site_id]} AND
        `tblAquaticSiteAgencyUse`.`AquaticActivityCd` = #{water_chemistry_sampling_activity_id} AND
        `tblAquaticActivity`.`AquaticActivityCd` = #{water_chemistry_sampling_activity_id}
      )
    }
    result = *AquaticSite.find_by_sql(query)
    sampling_events = result['sampling_events'].to_i
    sampling_events_with_created_at_timestamp = result['sampling_events_with_created_at_timestamp'].to_i
    # only legacy samples have no timestamps attached, so if the values aren't equal, then legacy data is present
    @has_legacy_samples = sampling_events > sampling_events_with_created_at_timestamp
    @undisplayed_samples = sampling_events - sampling_events_with_created_at_timestamp
    @agency_name = result['agency']
  end

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
