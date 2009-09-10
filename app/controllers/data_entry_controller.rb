class DataEntryController < ApplicationController
  before_filter :login_required
  
  def page_title
    :data_entry_page_title.l_with_args({ :action => "data_entry_#{action_name}_action".to_sym.l })
  end
  
  def current_location
    :data_entry_current_location.l
  end
  
  def uses_gmap?
    true
  end
    
  def browse  
    include_stylesheet 'calendar_date_select/default'
    include_javascript 'calendar_date_select/calendar_date_select'
  end
  
  def explore  
    include_javascript 'explore'
    
    area_of_interest = '%'    
    if session[:filter_area_of_interest] && current_user.area_of_interest
      aoi = current_user.area_of_interest.drainage_cd.split('-').collect { |unit_no| unit_no unless unit_no == '00' }.compact
      aoi << '%' if aoi.length < 6
      area_of_interest = aoi.join('-')
    end
    
    query = %Q{
      SELECT `tblAquaticSite`.`AquaticSiteID` AS aquatic_site_id,
        `tblAquaticSite`.`AquaticSiteName` AS aquatic_site_name,
        `tblAquaticSite`.`AquaticSiteDesc` AS aquatic_site_desc,
        `tblWaterBody`.`WaterBodyID` AS waterbody_id,
        `tblWaterBody`.`WaterBodyName` AS waterbody_name,
        `tblWaterBody`.`DrainageCd` AS drainage_code,
        `gmap_locations`.`longitude` AS longitude,
        `gmap_locations`.`latitude` AS latitude,
        COUNT(`tblAquaticActivity`.`AquaticActivityID`) AS aquatic_activity_event_count,
        COUNT(`tblSample`.`SampleID`) AS sample_count
      FROM `tblAquaticSite`
        LEFT OUTER JOIN `tblAquaticSiteAgencyUse` ON `tblAquaticSiteAgencyUse`.`AquaticSiteID` = `tblAquaticSite`.`AquaticSiteID`
        LEFT OUTER JOIN `tblAquaticActivity` ON `tblAquaticActivity`.`AquaticSiteID` = `tblAquaticSite`.`AquaticSiteID`
        LEFT OUTER JOIN `tblWaterBody` ON `tblWaterBody`.`WaterBodyID` = `tblAquaticSite`.`WaterBodyID`
        LEFT OUTER JOIN `gmap_locations` ON `gmap_locations`.`locatable_id` = `tblAquaticSite`.`AquaticSiteID` AND `gmap_locations`.`locatable_type` = 'AquaticSite'
        LEFT OUTER JOIN `tblSample` ON `tblSample`.`AquaticActivityID` = `tblAquaticActivity`.`AquaticActivityID`
      WHERE (
        `tblAquaticSite`.`WaterBodyID` IS NOT NULL AND
        `tblAquaticSiteAgencyUse`.`AquaticActivityCd` = 17 AND
        `tblAquaticActivity`.`AquaticActivityCd` = 17 AND
        `gmap_locations`.`longitude` IS NOT NULL AND
        `gmap_locations`.`latitude` IS NOT NULL AND
        `tblWaterBody`.`DrainageCd` LIKE '#{area_of_interest}'
      )
      GROUP BY aquatic_site_id
      ORDER BY aquatic_site_id ASC
    }    

    legacy_marker_count = 0
    @site_markers = AquaticSite.find_by_sql(query).collect do |query_row|
      result = query_row.attributes
      legacy_marker = result['sample_count'].to_i == 0

      marker = {
        :id => result['aquatic_site_id'],
        :latitude => result['latitude'],
        :longitude => result['longitude'],
        :legacy => legacy_marker,
        :info => render_to_string(
          :partial => 'data_collection_sites/info_window', 
          :locals => { :result => result }
        )          
      }
      legacy_marker_count += 1 if legacy_marker

      marker
    end

    @explore_legend_data = {
      :title => :explore_legend_title.l,
      :data_available => {
        :label => :explore_legend_data_available_label.l,
        :count => @site_markers.length - legacy_marker_count
      },
      :legacy_data_available => {
        :label => :explore_legend_legacy_data_available_label.l,
        :count => legacy_marker_count
      }
    }

    # some other translated items for the google map
    @loading_text     = :gmap_loading_text.l
    @max_window_title = :gmap_max_window_title.l
  end
end
