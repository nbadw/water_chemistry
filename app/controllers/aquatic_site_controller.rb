class AquaticSiteController < ApplicationController  
  active_scaffold do |config|    
    # base config
    config.label = "Data Collection Sites"    
    config.columns = [:incorporated, :id, :name, :description, :agencies, :waterbody_id, 
      :waterbody_name, :drainage_code, :name_and_description, :aquatic_activities] 
    
    config.columns[:incorporated].label = ''
    config.columns[:id].label = 'Site ID'
    config.columns[:agencies].label = 'Agency (Agency Site ID)'
    config.columns[:waterbody_id].label = 'Waterbody ID'
    config.columns[:drainage_code].label = 'Watershed Code'
    config.columns[:name].label = 'Site Name'
    config.columns[:name_and_description].label = 'Site Name & Description'  
    config.columns[:aquatic_activities].label = 'Data'    
    config.columns[:aquatic_activities].clear_link
    
    # list config
    config.columns[:id].sort_by :sql => "#{AquaticSite.table_name}.#{AquaticSite.primary_key}"
    config.columns[:drainage_code].sort_by :sql => "#{Waterbody.table_name}.#{Waterbody.drainage_code_column}"
    config.columns[:waterbody_id].sort_by :sql => "#{Waterbody.table_name}.#{Waterbody.primary_key}"
    config.columns[:waterbody_name].sort_by :sql => "#{Waterbody.table_name}.#{Waterbody.name_column}"
    config.list.columns.exclude :name, :description
    config.list.sorting =[{ :drainage_code => :asc }]
    
    # show config
    config.show.label = ''
    config.show.columns.exclude :incorporated, :name_and_description, :aquatic_activities
    
    # create config
    config.create.label = "Create a New Aquatic Site"
    config.create.columns = [:name, :description]
    config.create.columns.add_subgroup "Waterbody" do |waterbody| 
      waterbody.add :waterbody
    end
    config.create.columns.add_subgroup "Location" do |location|
      location.add :coordinate_source, :coordinate_system_id, :raw_latitude, :raw_longitude
      location.columns[:coordinate_system_id].label = 'Coordinate System'
      location.columns[:raw_latitude].label = 'Latitude'
      location.columns[:raw_longitude].label = 'Longitude'
    end
    
    # update config
    config.update.columns = [:name, :description]
    config.update.columns.add_subgroup "Waterbody" do |waterbody| 
      waterbody.add :waterbody
    end
    config.update.columns.add_subgroup "Location" do |location|
      location.add :coordinate_source, :coordinate_system_id, :raw_latitude, :raw_longitude
      location.columns[:coordinate_system_id].label = 'Coordinate System'
      location.columns[:raw_latitude].label = 'Latitude'
      location.columns[:raw_longitude].label = 'Longitude'
    
    end
        
    # search config
    config.columns[:id].search_sql = "#{AquaticSite.table_name}.#{AquaticSite.primary_key}"
    config.columns[:name].search_sql = "#{AquaticSite.table_name}.#{AquaticSite.name_column}"
    config.columns[:waterbody_id].search_sql = "#{Waterbody.table_name}.#{Waterbody.primary_key}"
    config.columns[:waterbody].search_sql = "#{Waterbody.table_name}.#{Waterbody.name_column}"
    config.columns[:drainage_code].search_sql = "#{Waterbody.table_name}.#{Waterbody.drainage_code_column}"  
    config.columns[:aquatic_activities].search_sql = "#{AquaticActivity.table_name}.#{AquaticActivity.name_column}"
    config.columns[:agencies].search_sql = "#{Agency.table_name}.#{Agency.code_column}"
    config.search.columns = [:id, :name, :waterbody_id, :waterbody, :drainage_code, :aquatic_activities, :agencies]
  end
  
  def conditions_for_collection
    ["#{AquaticSite.table_name}.#{AquaticSite.waterbody_id_column} != 0"]
  end
  
  def active_scaffold_joins
    [:waterbody, :aquatic_site_usages, :agencies, :aquatic_activities]
  end
 
  def auto_complete_for_waterbody_search
    query = params[:waterbody][:search]
    @waterbodies = Waterbody.search(query) unless query.blank?
    render :partial => "autocomplete" 
  end
  
  def gmap_max_content    
    render :inline => "<%= render :active_scaffold => 'tbl_aquatic_site', :conditions => ['#{AquaticSite.table_name}.aquaticsiteid = ?', params[:id]], :label => '' %>"
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
      :select => "#{Waterbody.drainage_code_column}", 
      :conditions => ["#{Waterbody.name_column} LIKE ?", query_term.strip]
    ).collect { |waterbody| waterbody.drainage_code }  
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
