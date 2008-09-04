class DataCollectionSitesController < ApplicationController  
  layout 'application'
  
  active_scaffold :aquatic_site do |config|
    config.columns = [:incorporated, :id, :name, :description, :water_body_id, :water_body_name, :drainage_code, :name_and_description, :aquatic_activities, :location]        
    #config.columns[:aquatic_activities].clear_link
    
    # list configuration
    config.list.columns = [:incorporated, :id, :agencies, :water_body_id, :water_body_name, :drainage_code, :name_and_description, :aquatic_activities]    
    #config.list.sorting =[{ :drainage_code => :asc }]

    # show configuration
    config.show.columns = [:id, :name, :description, :water_body_id, :water_body_name, :drainage_code, :location]
    
    # create configuration
    config.create.columns = [:name, :description]
    config.create.columns.add_subgroup "Waterbody" do |waterbody| 
      waterbody.add :waterbody
    end
    config.create.columns.add_subgroup "Location" do |location|
      location.add :coordinate_source, :coordinate_system, :x_coordinate, :y_coordinate
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
  end
  
  def auto_complete_for_waterbody_search
    query = params[:waterbody][:search]
    @waterbodies = Waterbody.search(query) unless query.blank?
    render :partial => "autocomplete" 
  end
  
  helper do
    def incorporated_column(aquatic_site)    
      '<img class="incorporated" src="/images/lock_delete.png"/>' if aquatic_site.incorporated?
    end
    
    def name_and_description_column(aquatic_site)
      description = [
        ("<span class=\"aquatic-site-name\">#{aquatic_site.name}</span>" if aquatic_site.name), 
        ("<span class=\"aquatic-site-description\">#{aquatic_site.description}</span>" if aquatic_site.description)
      ].compact.join('<br/>')       
      !description.empty? ? description : '-'
    end
    
    def drainage_code_column(aquatic_site)
      drainage_code = aquatic_site.waterbody.drainage_cd if aquatic_site.waterbody
      drainage_code || '-'
    end
  end
end
