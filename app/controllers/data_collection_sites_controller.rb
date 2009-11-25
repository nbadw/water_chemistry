class DataCollectionSitesController < ApplicationController  
  helper DataCollectionSitesHelper
  before_filter :login_required
  
  active_scaffold :aquatic_site do |config|
    # columns
    config.columns = [:incorporated, :id, :name, :aquatic_site_desc, :water_body_id, :water_body_name, :drainage_code, :name_and_description, :data_sets, :x_coordinate, :y_coordinate, :coordinate_system, :coordinate_source, :waterbody]
    config.list.columns = [:incorporated, :id, :agencies, :water_body_id, :water_body_name, :drainage_code, :name_and_description, :data_sets]    
    config.show.columns = [:id, :name, :aquatic_site_desc, :water_body_id, :water_body_name, :drainage_code, :x_coordinate, :y_coordinate, :coordinate_system, :coordinate_source]
    config.search.columns = [:id, :name, :water_body_id, :water_body_name, :drainage_code, :data_sets, :agencies]    
    [:create, :update].each do |action|  
      config.send(action).columns = [:name, :aquatic_site_desc]
      config.send(action).columns.add_subgroup :data_collection_sites_waterbody_subgroup.l do |waterbody|
        waterbody.add :waterbody
      end
      config.send(action).columns.add_subgroup :data_collection_sites_location_subgroup.l do |location|
        location.add :coordinate_source, :coordinate_system, :x_coordinate, :y_coordinate          
      end
    end
                 
    # set i18n labels
    logger.info "LOCALE: #{Globalite.current_locale}"
    config.label                                = :data_collection_sites_label
    config.create.label                         = :data_collection_sites_create_label
    config.show.label                           = '' # clear the title in the 'show' view
    config.columns[:incorporated].label         = '' # clear the incorporated column's label
    config.columns[:id].label                   = :aquatic_site_id_label
    config.columns[:name].label                 = :aquatic_site_name_label
    config.columns[:aquatic_site_desc].label    = :aquatic_site_desc_label
    config.columns[:agencies].label             = :aquatic_site_agencies_label
    config.columns[:water_body_id].label        = :aquatic_site_waterbody_id_label
    config.columns[:water_body_name].label      = :aquatic_site_waterbody_name_label
    config.columns[:drainage_code].label        = :aquatic_site_drainage_code_label
    config.columns[:name_and_description].label = :aquatic_site_name_and_description_label
    config.columns[:data_sets].label            = :aquatic_site_data_sets_label
    config.columns[:x_coordinate].label         = :aquatic_site_x_coordinate_label
    config.columns[:y_coordinate].label         = :aquatic_site_y_coordinate_label
    config.columns[:coordinate_system].label    = :aquatic_site_coordinate_system_label
    config.columns[:coordinate_source].label    = :aquatic_site_coordinate_source_label
    config.columns[:waterbody].label            = :data_collection_sites_waterbody_subgroup

    # set i18n descriptions
    config.columns[:name].description              = :aquatic_site_name_desc
    config.columns[:aquatic_site_desc].description = :aquatic_site_desc_desc

    # required fields
    config.columns[:aquatic_site_desc].required = true

    # sql for search 
    config.columns[:id].search_sql              = "#{AquaticSite.table_name}.#{AquaticSite.primary_key}"
    config.columns[:name].search_sql            = "#{AquaticSite.table_name}.#{AquaticSite.column_for_attribute(:aquatic_site_name).name}"
    config.columns[:water_body_id].search_sql   = "#{Waterbody.table_name}.#{Waterbody.primary_key}"
    config.columns[:water_body_name].search_sql = "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:water_body_name).name}"
    config.columns[:drainage_code].search_sql   = "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:drainage_cd).name}"
    config.columns[:data_sets].search_sql       = "#{AquaticActivity.table_name}.#{AquaticActivity.column_for_attribute(:aquatic_activity).name}"
    config.columns[:agencies].search_sql        = "#{Agency.table_name}.#{Agency.column_for_attribute(:agency_cd).name}"
    
    # sql for sorting 
    config.columns[:id].sort_by              :sql => "#{AquaticSite.table_name}.#{AquaticSite.primary_key}"
    config.columns[:drainage_code].sort_by   :sql => "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:drainage_cd).name}, #{AquaticSite.table_name}.#{AquaticSite.primary_key}"
    config.columns[:water_body_id].sort_by   :sql => "#{Waterbody.table_name}.#{Waterbody.primary_key}"
    config.columns[:water_body_name].sort_by :sql => "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:water_body_name).name}"
    config.columns[:data_sets].sort               = false
    config.columns[:agencies].sort                = false
        
    # action links
    config.columns[:aquatic_activities].clear_link
    
    # list customizations
    config.list.sorting =[{ :drainage_code => :asc }]
    #config.list.per_page = 50
  end
  
  def toggle_area_of_interest
    session[:filter_area_of_interest] = !session[:filter_area_of_interest] # toggle state
    # update table listing
    do_list
    render(:partial => 'list', :layout => false, :content_type => 'text/javascript')
  end
  
  def show_data_set_details
    constraints = { aquatic_site_id => params[:id], aquatic_activity => params[:aquatic_activity_id] }
  end
  
  def gmap_max_content   
    @aquatic_site = AquaticSite.find(params[:id], :include => :aquatic_activity_events)
    @site_usage = [*@aquatic_site.aquatic_site_usages].find { |usage| usage.aquatic_activity_cd == 17 }
    @water_chemistry_samplings = @aquatic_site.aquatic_activity_events.collect do |event|
      event if event.aquatic_activity_cd == 17
    end.compact.sort { |a, b| b.start_date.to_s <=> a.start_date.to_s }
    render :layout => false
  end
    
  def on_coordinate_source_change
    if params[:coordinate_source].blank?
      render :update do |page|   
        page.replace_html 'record_coordinate_system', :inline => ''  
        page << "$('record_coordinate_system').disabled = true;"
        page << "$('record_x_coordinate').disabled = true;" 
        page << "$('record_y_coordinate').disabled = true;"
      end
    else
      coordinate_source = CoordinateSource.find_by_name(params[:coordinate_source], :include => [:coordinate_systems])  
      choices = coordinate_source.coordinate_systems.collect { |system| [system.display_name, system.epsg] }
      render :update do |page|   
        page.replace_html 'record_coordinate_system', :inline => '<%= options_for_select choices %>', :locals => { :choices => choices }  
        page << "$('record_coordinate_system').disabled = false;"
        page << "$('record_x_coordinate').disabled = false;" 
        page << "$('record_y_coordinate').disabled = false;"
      end
    end
  end

  def on_preview_location
    begin
      point = Point.parse(params[:x], params[:y])
      raise "There may be a problem with the format of your coordinates." unless point

      url = 'http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer/project'
      query = {
        :f     => :json,
        :inSR  => params[:epsg],
        :outSR => 4326,
        :geometries => {
          :geometryType => :esriGeometryPoint,
          :geometries => [{
              :x => point.x,
              :y => point.y
            }]
        }.to_json
      }

      response = HTTParty.get(url, :query => query, :format => :json)
      if error = response["error"]
        raise "#{error["details"].join(', ')}"
      else
        geometry = response['geometries'].first
        x = geometry['x']
        y = geometry['y']
        render :update do |page|
          page << "show_preview_marker(#{x}, #{y});"
        end
      end
    rescue Exception => e
      message = 'There may be a problem with the format of your coordinates.'
      render :update do |page|
        page << "show_preview_message(#{message.to_json});"
      end
    end
  end
  
  def report   
    do_list
    aquatic_sites = @records
    options = {
      :report_on => aquatic_sites,
      :agency => current_user.agency
    }
    
    respond_to do |wants|
      wants.csv do
        csv = Reports::WaterChemistrySampling.render_csv(options)
        send_data csv, :type => "text/csv", :filename => "water_chemistry_sampling_report.csv" 
      end
    end 
  end

  def do_show
    super
    create_aquatic_site_map if @record
  end
  
  protected
  def before_create_save(aquatic_site)
    x = params[:record][:gmap_x]
    y = params[:record][:gmap_y]
    unless(x.to_s.empty? && y.to_s.empty?)
      aquatic_site.gmap_location = GmapLocation.new(:latitude => y, :longitude => x)
    end
  end

  def active_scaffold_joins
    [:waterbody, :aquatic_site_usages, :agencies, :aquatic_activities, :gmap_location]
  end
  
  def conditions_for_collection
    conditions = ["#{AquaticSite.table_name}.#{AquaticSite.column_for_attribute(:water_body_id).name} IS NOT NULL"]
    if session[:filter_area_of_interest] && current_user.area_of_interest && current_user.area_of_interest.drainage_cd
      conditions.first << " AND #{Waterbody.table_name}.#{Waterbody.column_for_attribute(:drainage_cd).name} LIKE ?"
      aoi = current_user.area_of_interest.drainage_cd.split('-').collect { |unit_no| unit_no unless unit_no == '00' }.compact
      aoi << '%' if aoi.length < 6
      conditions << aoi.join('-')
    end
    conditions
  end
  
  def do_search
    if params[:search]
      @query = params[:search]
      # XXX: i'd live to move this out of the session...
      session[:search] = @query
    else
      @query = session[:search]
    end
    @query = @query.to_s.strip rescue ''    
    return if @query.empty?
    
    columns = active_scaffold_config.search.columns
    query_terms = @query.split('+').collect{ |query_term| query_term.strip }
    query_terms.each { |query_term| construct_finder_conditions(query_term, columns) }      

    includes_for_search_columns = columns.collect{ |column| column.includes}.flatten.uniq.compact
    self.active_scaffold_joins.concat includes_for_search_columns

    active_scaffold_config.list.user.page = nil
  end  
    
  def construct_finder_conditions(query_term, columns)  
    # replace occurences of 'st' with 'st.'
    query_term = query_term.split(' ').collect { |word| word.match(/^(st)$/i) ? "#{$1}." : word }.join(' ')
    
    if query_term.match(/ watershed$/i)
      drainage_code_column = nil
      columns.each { |column| drainage_code_column = column if column.name == :drainage_code }
      finder_conditions = [
        "LOWER(#{drainage_code_column.search_sql}) IN (?)", 
        create_watershed_query_terms(query_term)
      ]
    else
      finder_conditions = ActiveScaffold::Finder.create_conditions_for_columns(query_term, columns, like_pattern(query_term))
    end    
    self.active_scaffold_conditions = merge_conditions(self.active_scaffold_conditions, finder_conditions)
  end
  
  def create_watershed_query_terms(query_term)
    query_term = "%#{query_term.sub(/watershed$/i, '').strip}%"
    find_drainage_codes(query_term)   
  end
  
  def find_drainage_codes(query_term)
    drainage_codes = Waterbody.find(:all, 
      :select => "#{Waterbody.column_for_attribute(:drainage_cd).name}", 
      :conditions => ["#{Waterbody.column_for_attribute(:water_body_name).name} LIKE ?", query_term.strip]
    ).collect { |waterbody| waterbody.drainage_cd }  
  end
  
  def like_pattern(query_term)
    if query_term.match(/^[1-9][\d]*$/) # id match
      '?'
    elsif query_term.match(/^\d[-\d]*$/) # drainage code match
      '?%'
    else
      '%?%'
    end
  end

  private
  def create_aquatic_site_map
    return unless @record.gmap_location

    @aquatic_site_map = GMap.new("aquatic-site-map")
    @aquatic_site_map.set_map_type_init(GMapType::G_HYBRID_MAP)
    @aquatic_site_map.control_init(:small_zoom => true)
    @aquatic_site_map.center_zoom_init([@record.gmap_location.latitude, @record.gmap_location.longitude], 6)
    @aquatic_site_map.overlay_init(GMarker.new([@record.gmap_location.latitude, @record.gmap_location.longitude]))
  end
end
