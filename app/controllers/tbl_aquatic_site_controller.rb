class TblAquaticSiteController < ApplicationController
  active_scaffold do |config|    
    # base config
    config.label = "Aquatic Sites"    
    config.columns = [:incorporated, :id, :name, :agencies, :waterbody_id, :waterbody_name, 
      :drainage_code, :description, :aquatic_activity_codes, :coordinates] 
    
    config.columns[:incorporated].label = ''
    config.columns[:id].label = 'Site Id'
    config.columns[:agencies].label = 'Agency (Agency Site ID)'
    config.columns[:waterbody_id].label = 'Waterbody Id'
    config.columns[:drainage_code].label = 'Watershed Code'
    config.columns[:name].label = 'Site Name'
    config.columns[:description].label = 'Site Description'  
    config.columns[:aquatic_activity_codes].label = 'Data'    
    config.columns[:aquatic_activity_codes].clear_link
    
    # list config
    config.columns[:id].sort_by :sql => "#{TblAquaticSite.table_name}.#{TblAquaticSite.primary_key}"
    config.columns[:drainage_code].sort_by :sql => "#{TblWaterbody.table_name}.drainagecd"
    config.columns[:waterbody_id].sort_by :sql => "#{TblWaterbody.table_name}.#{TblWaterbody.primary_key}"
    config.columns[:waterbody_name].sort_by :sql => "#{TblWaterbody.table_name}.waterbodyname"
    config.list.columns.exclude :name, :coordinates
    config.list.sorting =[{ :drainage_code => :asc }]
    
    # show config
    config.show.label = ''
    config.show.columns.exclude :incorporated, :name, :aquatic_activity_codes
    
    # create config
    config.create.label = "Create a New Aquatic Site"
    config.create.columns = [:name, :description]
    config.create.columns.add_subgroup "Waterbody" do |waterbody| 
      waterbody.add :waterbody
    end
    config.create.columns.add_subgroup "Location" do |location|
      location.add :coordinates
    end
    
    # update config
    config.update.columns = [:name, :description]
    config.update.columns.add_subgroup "Waterbody" do |waterbody| 
      waterbody.add :waterbody
    end
    config.update.columns.add_subgroup "Location" do |location|
      location.add :coordinates
    end
        
    # search config
    config.columns[:name].search_sql = "#{TblAquaticSite.table_name}.aquaticsitename"
    config.columns[:waterbody_id].search_sql = "#{TblWaterbody.table_name}.waterbodyid"
    config.columns[:waterbody].search_sql = "#{TblWaterbody.table_name}.waterbodyname"
    config.columns[:drainage_code].search_sql = "#{TblWaterbody.table_name}.drainagecd"  
    config.columns[:aquatic_activity_codes].search_sql = "#{CdAquaticActivity.table_name}.aquaticactivity"
    config.columns[:agencies].search_sql = "#{TblAquaticSiteAgencyUse.table_name}.agencycd"
    config.search.columns = [:name, :waterbody_id, :waterbody, :drainage_code, :aquatic_activity_codes, :agencies]
  end
  
  def conditions_for_collection
    ["#{TblAquaticSite.table_name}.#{TblAquaticSite.primary_key} > 0 AND #{TblAquaticSite.table_name}.waterbodyid IS NOT NULL"]
  end
  
  def active_scaffold_joins
    [:waterbody, :aquatic_site_agency_usages, :agencies, :aquatic_activity_codes]
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
