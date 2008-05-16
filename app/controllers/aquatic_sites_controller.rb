class AquaticSitesController < ApplicationController
  layout 'admin'
    
  active_scaffold :aquatic_site do |config|    
    # base config
    config.columns = [:id, :name, :agencies, :waterbody_id, :waterbody, 
      :drainage_code, :description, :activities]        
    config.columns[:id].label = 'Aquatic Site ID'
    config.columns[:waterbody_id].label = 'Waterbody ID'
    config.columns[:waterbody].label = 'Waterbody Name'
    config.columns[:drainage_code].label = 'Watershed Code'
    config.columns[:name].label = 'Site Name'
    config.columns[:description].label = 'Site Description'  
    
    config.columns[:activities].clear_link
    
    # list config
    config.columns[:drainage_code].sort_by :sql => 'waterbodies.drainage_code'
    config.list.columns.exclude :name
    config.list.sorting =[{ :drainage_code => :asc }]
    
    # create config
    config.create.columns = [:agency, :name, :description, :waterbody]
    
    # update config
    config.update.columns = [:agency, :name, :description, :waterbody]
        
    # search config
    config.columns[:waterbody_id].search_sql = 'waterbodies.id'
    config.search.columns << :waterbody_id
    config.columns[:waterbody].search_sql = 'waterbodies.name'
    config.search.columns << :waterbody
    config.columns[:drainage_code].search_sql = 'waterbodies.drainage_code'    
    config.search.columns << :drainage_code
    config.columns[:activities].search_sql = 'activities.name'
    config.search.columns << :activities
    config.columns[:agencies].search_sql = 'aquatic_site_usages.agency_code'
    config.search.columns << :agencies
  end
  
  def conditions_for_collection
    ['aquatic_sites.id > 0 AND waterbody_id IS NOT NULL']
  end
  
  def active_scaffold_joins
    [:waterbody, :aquatic_site_usages, :activities]
  end
  
  def auto_complete_for_waterbody_contains
    query = params[:waterbody][:contains]
    @waterbodies = Waterbody.search(query) unless query.blank?
    render :partial => "autocomplete" 
  end
end
