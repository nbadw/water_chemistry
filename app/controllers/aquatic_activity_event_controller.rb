class AquaticActivityEventController < ApplicationController  
  before_filter :find_aquatic_activity_methods, :only => [:new, :create]
  
  active_scaffold do |config|
    # base config 
    config.label = "Aquatic Activities"
    config.actions.exclude :search
    
    config.columns = [:aquatic_site_id, :aquatic_activity_cd, :aquatic_activity_method, :start_date, :agency, :weather_conditions, :water_level]
    config.list.columns = [:aquatic_activity_method, :start_date, :agency, :weather_conditions, :water_level]
    config.show.columns = [:aquatic_activity_method, :start_date, :agency, :weather_conditions, :water_level]
        
    config.columns[:aquatic_site_id].search_sql = "#{AquaticActivityEvent.table_name}.#{AquaticActivityEvent.column_for_attribute(:aquatic_site_id).name}"    
    config.columns[:aquatic_activity_cd].search_sql = "#{AquaticActivityEvent.table_name}.#{AquaticActivityEvent.column_for_attribute(:aquatic_activity_cd).name}"
   
#    config.columns = [:aquatic_activity_method, :start_date, :agency, 
#      :weather_conditions, :rain_fall_in_last_24_hours, :water_level]
    config.columns[:aquatic_activity_method].label = "Analysis Method"
    config.columns[:start_date].label = "Date"
    config.columns[:weather_conditions].label = "Weather Conditions"
    config.columns[:water_level].label = "Water Level"
#    config.columns[:rain_fall_in_last_24_hours].label = "Rain Fall In Last 24 Hrs"
#    
#    # list config    
    config.columns[:start_date].sort_by :method => "#{self.name}.to_s"    
    config.list.sorting = [{ :start_date => :desc }]
#        
#    # create config  
#    config.create.label = "Create New Sampling Event"
#    config.create.columns = []
#    config.create.columns.add_subgroup "Sampling Event Info" do |sampling_info| 
#      sampling_info.add :aquatic_activity_method, :start_date, :crew
#      sampling_info.columns[:start_date].label = "Date"
#      sampling_info.columns[:crew].label = "Personnel"
#    end
#    config.create.columns.add_subgroup "Weather Observations" do |weather_observations|
#      weather_observations.add :rain_fall_in_last_24_hours, :weather_conditions
#    end
#      
    config.update.link.inline = false
    config.show.link.inline = false    
    config.action_links.add 'add_site_id', :label => 'Add Site ID'    
  end
  
  def find_aquatic_activity_methods
    @aquatic_activity_methods = AquaticActivityMethod.find(:all,
      :conditions => [
        "#{AquaticActivityMethod.column_for_attribute(:aquatic_activity_cd).name} = ?", 
        active_scaffold_session_storage[:constraints][:aquatic_activity_cd]        
      ]
    )
  end
  
  def edit
    event = AquaticActivityEvent.find params[:id], :include => :aquatic_activity
    activity_name = event.aquatic_activity.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'edit', 
      :aquatic_activity_event_id => event.id, :aquatic_site_id => event.aquatic_site_id
  end
  
  def show
    event = AquaticActivityEvent.find params[:id], :include => :aquatic_activity
    activity_name = event.aquatic_activity.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'show', 
      :aquatic_activity_event_id => event.id, :aquatic_site_id => event.aquatic_site_id
  end
  
  def aquatic_site_activities    
    @label = params[:label]       
    @constraints = { :aquatic_site_id => params[:aquatic_site_id], :aquatic_activity_cd => params[:aquatic_activity_id] }  
    render :layout => false
  end
  
  def details
    @record = AquaticActivityEvent.find params[:aquatic_activity_event_id] 
    render :action => 'show', :layout => false
  end
  
  def before_create_save(aquatic_activity_event)
    aquatic_activity_event.aquatic_site_id = active_scaffold_session_storage[:constraints][:aquatic_site_id]
    aquatic_activity_event.aquatic_activity_cd = active_scaffold_session_storage[:constraints][:aquatic_activity_cd].to_i
    aquatic_activity_event.agency_cd = current_user.agency.id
  end
end
