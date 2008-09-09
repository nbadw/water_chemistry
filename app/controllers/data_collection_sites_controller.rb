class DataCollectionSitesController < ApplicationController  
  layout 'application'
  helper DataCollectionSitesHelper
  
  active_scaffold :aquatic_site do |config|
    # columns
    config.columns = [:incorporated, :id, :name, :description, :water_body_id, :water_body_name, :drainage_code, :name_and_description, :aquatic_activities, :location]        
    config.list.columns = [:incorporated, :id, :agencies, :water_body_id, :water_body_name, :drainage_code, :name_and_description, :aquatic_activities]    
    config.show.columns = [:id, :name, :description, :water_body_id, :water_body_name, :drainage_code, :location]
    config.search.columns = [:id, :name, :water_body_id, :water_body_name, :drainage_code, :aquatic_activities, :agencies]    
    [:create, :update].each do |action|  
      config.send(action).columns = [:name, :description]
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
    config.columns[:id].label = 'Site ID'
    config.columns[:agencies].label = 'Agency (Agency Site ID)'
    config.columns[:water_body_id].label = 'Waterbody ID'
    config.columns[:water_body_name].label = 'Waterbody Name'
    config.columns[:drainage_code].label = 'Watershed Code'
    config.columns[:name].label = 'Site Name'
    config.columns[:name_and_description].label = 'Site Name & Description'  
    config.columns[:aquatic_activities].label = 'Data'  
    
    # sql for search 
    config.columns[:id].search_sql = "#{AquaticSite.table_name}.#{AquaticSite.primary_key}"
    config.columns[:name].search_sql = "#{AquaticSite.table_name}.#{AquaticSite.column_for_attribute(:aquatic_site_name).name}"
    config.columns[:water_body_id].search_sql = "#{Waterbody.table_name}.#{Waterbody.primary_key}"
    config.columns[:water_body_name].search_sql = "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:water_body_name).name}"
    config.columns[:drainage_code].search_sql = "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:drainage_cd).name}"  
    config.columns[:aquatic_activities].search_sql = "#{AquaticActivity.table_name}.#{AquaticActivity.column_for_attribute(:aquatic_activity).name}"
    config.columns[:agencies].search_sql = "#{Agency.table_name}.#{Agency.column_for_attribute(:agency_cd).name}"
    
    # sql for sorting 
    config.columns[:id].sort_by :sql => "#{AquaticSite.table_name}.#{AquaticSite.primary_key}"
    config.columns[:drainage_code].sort_by :sql => "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:drainage_cd).name}"
    config.columns[:water_body_id].sort_by :sql => "#{Waterbody.table_name}.#{Waterbody.primary_key}"
    config.columns[:water_body_name].sort_by :sql => "#{Waterbody.table_name}.#{Waterbody.column_for_attribute(:water_body_name).name}"
        
    # action links
    #config.columns[:aquatic_activities].clear_link
    config.columns[:agencies].set_link('nested', :controller => 'agencies', :action => 'test')
    config.columns[:drainage_code].set_link('nested', :controller => 'data_collection_sites', :action => 'explain_drainage_code')
    config.action_links.add 'toggle_area_of_interest', :label => 'Toggle Area of Interest'
    
    # list customizations
    config.list.sorting =[{ :drainage_code => :asc }]
    config.list.per_page = 50
  end
  
  # TODO: this link will have to be rendered in a frontend view override
  def toggle_area_of_interest
    # what is the current state?
    #   session[:area_of_interest_only] = true | false
    # if true
    #   set to false
    #   send javascript to change link class to off
    # else
    #   set to true
    #   send javascript to change link class to on
    # end
    state = session[:area_of_interest_only] ? 'on' : 'off'
    session[:area_of_interest_only] = !session[:area_of_interest_only] # toggle state
    render :update do |page|
      page << "$('#{action_link_id('toggle_area_of_interest', nil)}').addClassName('#{state}');"
    end
  end
  
  def add_data_set
    unattached_data_sets = AquaticSite.find(params[:id]).unattached_data_sets
  end
  
  def show_data_set_details
    constraints = { aquatic_site_id => params[:id], aquatic_activity => params[:aquatic_activity_id] }
  end
  
  def gmap_max_content    
    render :inline => "<%= render :active_scaffold => 'tbl_aquatic_site', :conditions => ['#{AquaticSite.table_name}.aquaticsiteid = ?', params[:id]], :label => '' %>"
  end
  
  def explain_drainage_code
    aquatic_site = AquaticSite.find params[:id]
    waterbody = aquatic_site.waterbody
    drainage_unit = waterbody.drainage_unit if waterbody
    if drainage_unit
      names = []
      (1..6).each { |i| names << drainage_unit.send("level#{i}_name") }      
      render :text => names.compact.join(' - ')
    else
      render :text => 'NO DRAINAGE UNIT!'
    end
  end
  
  def auto_complete_for_waterbody_search
    query = params[:waterbody][:search]
    @waterbodies = Waterbody.search(query) unless query.blank?
    render :partial => "autocomplete" 
  end
  
  def active_scaffold_joins
    [:waterbody, :aquatic_site_usages, :agencies, :aquatic_activities]
  end
  
  def conditions_for_collection
    ["#{AquaticSite.table_name}.#{AquaticSite.column_for_attribute(:water_body_id).name} IS NOT NULL"]
  end
  
  def do_search
    @query = params[:search].to_s.strip rescue ''
    return if @query.empty?
    
    columns = active_scaffold_config.search.columns
    query_terms = @query.split('+').collect{ |query_term| query_term.strip }
    query_terms.each { |query_term| construct_finder_conditions(query_term, columns) }      

    includes_for_search_columns = columns.collect{ |column| column.includes}.flatten.uniq.compact
    self.active_scaffold_joins.concat includes_for_search_columns

    active_scaffold_config.list.user.page = nil
  end
  
  def on_coordinate_source_change
    if params[:coordinate_source_id].blank?
      render :update do |page|   
        #page.replace_html 'coordinate_system_input', :inline => '<%= recorded_location_coordinate_system_input(@record) %>'  
        page << "$('record_coordinate_system_id').disabled = true;"
        page << "$('record_raw_latitude').disabled = true;" 
        page << "$('record_raw_longitude').disabled = true;"
      end
    else
      coordinate_source = CoordinateSource.find(params[:coordinate_source_id], :include => [:coordinate_systems])  
      choices = coordinate_source.coordinate_systems.collect { |source| [source.display_name, source.id] }
      render :update do |page|   
        page.replace_html 'record_coordinate_system_id', :inline => '<%= options_for_select choices %>', :locals => { :choices => choices }  
        page << "$('record_coordinate_system_id').disabled = false;"
        page << "$('record_raw_latitude').disabled = false;" 
        page << "$('record_raw_longitude').disabled = false;"
      end
    end
  end    
  
  private  
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
end
