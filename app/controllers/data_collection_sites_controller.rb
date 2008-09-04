class DataCollectionSitesController < ApplicationController  
  layout 'application'
  
  active_scaffold :aquatic_site do |config|
    # columns
    config.columns = [:incorporated, :id, :name, :description, :water_body_id, :water_body_name, :drainage_code, :name_and_description, :aquatic_activities, :location]        
    config.list.columns = [:incorporated, :id, :agencies, :water_body_id, :water_body_name, :drainage_code, :name_and_description, :aquatic_activities]    
    config.show.columns = [:id, :name, :description, :water_body_id, :water_body_name, :drainage_code, :location]
    config.search.columns = [:id, :name, :water_body_id, :water_body_name, :drainage_code] #, :aquatic_activities, :agencies]
    config.create.columns = [:name, :description]
    config.create.columns.add_subgroup "Waterbody" do |waterbody| 
      waterbody.add :waterbody
    end
    config.update.columns.add_subgroup "Location" do |location|
      location.add :coordinate_source, :coordinate_system, :x_coordinate, :y_coordinate
    end
    config.update.columns = [:name, :description]
    config.update.columns.add_subgroup "Waterbody" do |waterbody| 
      waterbody.add :waterbody
    end
    config.update.columns.add_subgroup "Location" do |location|
      location.add :coordinate_source, :coordinate_system, :x_coordinate, :y_coordinate
    end
        
    #config.columns[:aquatic_activities].clear_link
    config.list.sorting =[{ :drainage_code => :asc }]
         
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
    
    def agencies_column(record)      
      agency_site_id_hash = {}
      record.aquatic_site_usages.each do |aquatic_site_usage|
        if agency_cd = aquatic_site_usage.agency_cd      
          (agency_site_id_hash[agency_cd] ||= []) << aquatic_site_usage.agency_site_id unless aquatic_site_usage.agency_site_id.to_s.empty?
        end
      end
    
      record.agencies.uniq.collect do |agency|      
        agency_site_ids = agency_site_id_hash[agency.id] || []
        site_id_text = "(" + agency_site_ids.uniq.join(', ') + ")" unless agency_site_ids.empty?
        ["#{agency.code}", site_id_text, "<br/>"]
      end.flatten.compact.join(' ')
    end
    
    def aquatic_activities_column(record)
      options = { :_method => 'get', :action => 'aquatic_site_activities',
        :aquatic_site_id => record.id, :controller => 'aquatic_activity_event' }
    
      html_options = { :class => 'nested action', :position => 'after',
        :id => "aquatic_sites-nested-#{record.id}-link" }
    
      # create links to inline site activities
      links = record.aquatic_activities.uniq.sort.collect do |aquatic_activity|      
        options[:aquatic_activity_id] = aquatic_activity.id
        options[:label] = "#{aquatic_activity.name} for Site ##{record.id} - #{record.name}"
        # XXX: limiting to only water chemistry sampling activities, the rest are disabled
        if aquatic_activity.name == 'Water Chemistry Sampling'
          link_to aquatic_activity.name, options, html_options
        else
          '<a href="#" class="disabled">' + aquatic_activity.name + '</a>'
        end
      end
    
      # create default link to create a new activity
      links << link_to('Add a new data set', { :_method => 'get', :controller => 'aquatic_site_usage',
          :action => 'new', :aquatic_site_id => record.id, :format => 'js' }, { :class => 'nested action', 
          :position => 'after', :id => "aquatic_sites-nested-#{record.id}-link" })
    
      links.join('<br/><br/>')
    end
  end
end
