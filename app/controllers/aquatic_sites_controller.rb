class AquaticSitesController < ApplicationController
  before_filter :full_or_simple_table_config
  
  layout 'admin'
  
  active_scaffold :aquatic_site do |config|
    config.columns = [:id, :name, :agencies, :waterbody_id,
      :waterbody, :drainage_code, :description, :activities]
        
    config.columns[:id].label = 'Aquatic Site ID'
    config.columns[:waterbody_id].label = 'Waterbody ID'
    config.columns[:waterbody].label = 'Waterbody Name'
    config.columns[:drainage_code].label = 'Watershed Code'
    config.columns[:name].label = 'Site Name'
    config.columns[:description].label = 'Site Description'
    
    config.list.columns.exclude :name
    
    config.create.columns = [:agency, :name, :description, :waterbody]
  end
  
  def conditions_for_collection
    ['aquatic_sites.id > 0']
  end
  
  def auto_complete_for_waterbody_contains
    query = params[:waterbody][:contains]
    @waterbodies = Waterbody.search("%#{query}%") unless query.blank?
    render :partial => "live/search" 
  end
  
  def full_or_simple_table_config
    if params['list_type'] == 'simple'
      
    end
  end
end
