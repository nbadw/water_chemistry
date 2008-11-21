class DataCollectionSitesController < ApplicationController  
  helper DataCollectionSitesHelper
  before_filter :login_required
  
  active_scaffold :aquatic_site do |config|
    # columns
    config.columns = [:incorporated, :id, :name, :aquatic_site_desc, :water_body_id, :water_body_name, :drainage_code, :name_and_description, :data_sets, :x_coordinate, :y_coordinate, :coordinate_system]        
    config.list.columns = [:incorporated, :id, :agencies, :water_body_id, :water_body_name, :drainage_code, :name_and_description, :data_sets]    
    config.show.columns = [:id, :name, :aquatic_site_desc, :water_body_id, :water_body_name, :drainage_code, :x_coordinate, :y_coordinate, :coordinate_system]
    config.search.columns = [:id, :name, :water_body_id, :water_body_name, :drainage_code, :data_sets, :agencies]    
    [:create, :update].each do |action|  
      config.send(action).columns = [:name, :aquatic_site_desc]
      config.send(action).columns.add_subgroup "Waterbody" do |waterbody| 
        waterbody.add :waterbody
      end
      config.send(action).columns.add_subgroup "Location" do |location|
        location.add :coordinate_source, :coordinate_system, :x_coordinate, :y_coordinate          
      end
    end
                 
    # set i18n labels    
    config.label = "Data Collection Sites"
    config.show.label = ''
    config.columns[:incorporated].label = ''
    config.columns[:id].label = 'ADW Site ID'
    config.columns[:aquatic_site_desc].label = 'Description'
    config.columns[:agencies].label = 'Agency (Agency Site ID)'
    config.columns[:water_body_id].label = 'Waterbody ID'
    config.columns[:water_body_name].label = 'Waterbody Name'
    config.columns[:drainage_code].label = 'Watershed Code'
    config.columns[:name].label = 'Site Name'
    config.columns[:name_and_description].label = 'Site Name & Description'  
    config.columns[:data_sets].label = 'Data'  
    config.columns[:x_coordinate].label = 'X Coordinate'
    config.columns[:y_coordinate].label = 'Y Coordinate'
    config.columns[:coordinate_system].label = 'Coordinate System'
    config.create.label = 'Create New Data Collection Site'

    # set i18n descriptions
    config.columns[:name].description = 'Sometimes sites have a common name, like Mactaquac Dam, Titus Bridge or Kennebecasis Counting Fence'
    config.columns[:aquatic_site_desc].description = 'Description of where the site is located or driving directions. It is particularly important to complete this field when sites are remote locations, especially when GPS coordinates are not provided or recorded incorrectly.'
    config.columns[:waterbody].description = 'Test'

    # required fields
    config.columns[:aquatic_site_desc].required = true

    # sql for search 
    config.columns[:id].search_sql = "#{AquaticSite.table_name}.#{AquaticSite.primary_key}"
    config.columns[:name].search_sql = "#{AquaticSite.table_name}.#{AquaticSite.column_for_attribute(:aquatic_site_name).name}"
    config.columns[:water_body_id].search_sql = "#{Waterbody.table_name}.#{Waterbody.primary_key}"
    config.columns[:water_body_name].search_sql = "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:water_body_name).name}"
    config.columns[:drainage_code].search_sql = "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:drainage_cd).name}"  
    config.columns[:data_sets].search_sql = "#{AquaticActivity.table_name}.#{AquaticActivity.column_for_attribute(:aquatic_activity).name}"
    config.columns[:agencies].search_sql = "#{Agency.table_name}.#{Agency.column_for_attribute(:agency_cd).name}"
    
    # sql for sorting 
    config.columns[:id].sort_by :sql => "#{AquaticSite.table_name}.#{AquaticSite.primary_key}"
    config.columns[:drainage_code].sort_by :sql => "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:drainage_cd).name}, #{AquaticSite.table_name}.#{AquaticSite.primary_key}"
    config.columns[:water_body_id].sort_by :sql => "#{Waterbody.table_name}.#{Waterbody.primary_key}"
    config.columns[:water_body_name].sort_by :sql => "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:water_body_name).name}"
    config.columns[:data_sets].sort = false
    config.columns[:agencies].sort = false
        
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
  
  def select_data_set
    @unattached_data_sets = AquaticSite.find(params[:id]).unattached_data_sets
    respond_to do |wants|
      wants.html { render :layout => false }
    end
  end
  
  def add_data_set
    site     = AquaticSite.find params[:aquatic_site][:id]
    activity = AquaticActivity.find params[:aquatic_site][:data_set]
    agency   = current_user.agency     
  rescue Exception => exc
    logger.error exc.message
    render :text => 'An error occured while attempting to process your request.  Please try again later.'
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
      choices = coordinate_source.coordinate_systems.collect { |source| [source.display_name, source.display_name] }
      render :update do |page|   
        page.replace_html 'record_coordinate_system', :inline => '<%= options_for_select choices %>', :locals => { :choices => choices }  
        page << "$('record_coordinate_system').disabled = false;"
        page << "$('record_x_coordinate').disabled = false;" 
        page << "$('record_y_coordinate').disabled = false;"
      end
    end
  end 
  
  def on_preview_location
    aquatic_site = update_record_from_params(active_scaffold_config.model.new, active_scaffold_config.create.columns, params[:record] || {})
    location = aquatic_site.location
    
    if location.valid?
      begin
        gmap_location = location.convert_to_gmap_location
        if gmap_location
          @map = GMap.new("preview-location-map")
          @map.set_map_type_init(GMapType::G_HYBRID_MAP)
          @map.control_init(:small_zoom => true)
          @map.center_zoom_init([gmap_location.latitude, gmap_location.longitude], 8)
          @map.overlay_init(GMarker.new([gmap_location.latitude, gmap_location.longitude]))
        else
          @messages = ["An unknown error occured.  Please try again later."]
        end
      rescue Exception => e
        @messages = ["An unknown error occurred.  Please try again later. (#{e.message})"]
      end
    else
      if location.blank?
        @messages = ['Please enter all location details first.']
      else
        aquatic_site.valid? # run aquatic site validations to get proper error messages
        @messages = []
        [:x_coordinate, :y_coordinate, :coordinate_system].each do |attr|
          aquatic_site.errors.on(attr).to_a.each do |msg|
            next if msg.nil?
            @messages << active_scaffold_config.columns[attr].label + " " + msg
          end
        end
      end
    end
    
    render :layout => 'map_iframe'
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
