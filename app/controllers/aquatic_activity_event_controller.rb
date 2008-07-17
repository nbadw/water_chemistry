class AquaticActivityEventController < ApplicationController  
  active_scaffold do |config|
    # base config 
    config.label = "Aquatic Activities"    
    config.columns = [:aquatic_activity_method, :start_date, :agency, 
      :weather_conditions, :rain_fall_in_last_24_hours, :water_level]
    config.columns[:start_date].label = "Start Date (DD/MM/YY)"
    
    # list config    
    config.columns[:start_date].sort_by :method => "#{self.name}.to_s"    
    config.list.sorting = [{ :start_date => :desc }]
        
    # create config  
    config.create.columns = []
    config.create.columns.add_subgroup "Sampling Info" do |sampling_info| 
      sampling_info.add :aquatic_activity_method, :start_date, :crew
      sampling_info.columns[:start_date].label = "Start Date"
      sampling_info.columns[:crew].label = "Personnel"
    end
    config.create.columns.add_subgroup "Weather Observations" do |weather_observations|
      weather_observations.add :rain_fall_in_last_24_hours, :weather_conditions
      weather_observations.collapsed = true
    end
    config.create.columns.add_subgroup "Water Observations" do |water_observations|
      water_observations.add :water_level, :water_clarity, :water_color      
      water_observations.collapsed = true
    end
    config.create.columns.add_subgroup "Environmental Issues" do |environmental_issues|      
      environmental_issues.add :water_crossing, :point_source, :non_point_source, :watercourse_alteration
      environmental_issues.collapsed = true
    end
      
    config.update.link.inline = false
    config.show.link.inline = false
  end
  
  def new
    @aquatic_activity_methods = AquaticActivityMethod.find_all_by_aquatic_activity_id active_scaffold_session_storage[:constraints][:aquatic_activity_id]
    super
  end
  
  def create
    @aquatic_activity_methods = AquaticActivityMethod.find_all_by_aquatic_activity_id active_scaffold_session_storage[:constraints][:aquatic_activity_id]
    super
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
    @constraints = { :aquatic_site_id => params[:aquatic_site_id], :aquatic_activity_id => params[:aquatic_activity_id] }  
    render :layout => false
  end
  
  def details
    @record = AquaticActivityEvent.find params[:aquatic_activity_event_id]
    render :action => 'show', :layout => false
  end
  
  def before_create_save(record)
    record.aquatic_site_id = active_scaffold_session_storage[:constraints][:aquatic_site_id]
    record.aquatic_activity_id = active_scaffold_session_storage[:constraints][:aquatic_activity_id]
    record.agency_id = current_user.agency.id
  end
end
