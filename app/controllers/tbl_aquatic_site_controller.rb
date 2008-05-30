class TblAquaticSiteController < ApplicationController
  active_scaffold do |config|    
    # base config
    config.label = "Aquatic Sites"    
    config.columns = [:id, :name, :agencies, :waterbody_id, :waterbody_name, 
      :drainage_code, :description, :aquatic_activity_codes]  
    config.columns[:waterbody_id].label = 'Waterbody Id'
    config.columns[:drainage_code].label = 'Watershed Code'
    config.columns[:name].label = 'Site Name'
    config.columns[:description].label = 'Site Description'  
    config.columns[:aquatic_activity_codes].label = 'Activities'
    
    config.columns[:aquatic_activity_codes].clear_link
    
    # list config
    config.columns[:drainage_code].sort_by :sql => "#{TblWaterbody.table_name}.drainagecd"
    config.list.columns.exclude :name
    config.list.sorting =[{ :drainage_code => :asc }]
    
    # create config
    config.create.label = "Create a New Aquatic Site"
    config.create.columns = [:agency, :name, :description, :waterbody]
    
    # update config
    config.update.columns = [:agency, :name, :description, :waterbody]
        
    # search config
    config.columns[:waterbody_id].search_sql = "#{TblWaterbody.table_name}.waterbodyid"
    config.search.columns << :waterbody_id
    config.columns[:waterbody].search_sql = "#{TblWaterbody.table_name}.waterbodyname"
    config.search.columns << :waterbody
    config.columns[:drainage_code].search_sql = "#{TblWaterbody.table_name}.drainagecd"    
    config.search.columns << :drainage_code
    config.columns[:aquatic_activity_codes].search_sql = "#{CdAquaticActivity.table_name}.aquaticactivity"
    config.search.columns << :aquatic_activity_codes
    config.columns[:agencies].search_sql = "#{TblAquaticSiteAgencyUse.table_name}.agencycd"
    config.search.columns << :agencies
  end
  
  def conditions_for_collection
    ["#{TblAquaticSite.table_name}.#{TblAquaticSite.primary_key} > 0 AND #{TblAquaticSite.table_name}.waterbodyid IS NOT NULL"]
  end
  
  def active_scaffold_joins
    [:waterbody, :aquatic_site_agency_usages, :aquatic_activity_codes]
  end
 
  def auto_complete_for_waterbody_search
    query = params[:waterbody][:search]
    @waterbodies = TblWaterbody.search(query) unless query.blank?
    render :partial => "autocomplete" 
  end
  
  def gmap_max_content    
    render :inline => "<%= render :active_scaffold => 'tbl_aquatic_site', :conditions => ['#{TblAquaticSite.table_name}.aquaticsiteid = ?', params[:id]], :label => '' %>"
  end
end
