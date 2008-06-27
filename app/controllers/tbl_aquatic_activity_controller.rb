  class TblAquaticActivityController < ApplicationController  
  active_scaffold :tbl_aquatic_activity do |config|
    # base config 
    config.label = "Aquatic Activities"    
    config.columns = [:aquatic_activity_method_code, :start_date, :agency, 
      :weather_conditions, :rain_fall_in_last_24_hours, :water_level]
    config.columns[:start_date].label = "Start Date (DD/MM/YY)"
    
    # list config    
    config.columns[:start_date].sort_by :method => "#{self.name}.to_s"    
    config.list.sorting = [{ :start_date => :desc }]
        
    # create config  
    config.create.columns = []
    config.create.columns.add_subgroup "Sampling Info" do |sampling_info| 
      sampling_info.add :aquatic_activity_method_code, :start_date, :crew
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
  
  alias_method :active_scaffold_new, :new
  def new
    @aquatic_activity_method_codes = AquaticActivityMethod.find_all_by_aquaticactivitycd active_scaffold_session_storage[:constraints][:aquaticactivitycd]
    active_scaffold_new
  end
  
  alias_method :active_scaffold_create, :create
  def create
    @aquatic_activity_method_codes = AquaticActivityMethod.find_all_by_aquaticactivitycd active_scaffold_session_storage[:constraints][:aquaticactivitycd]
    active_scaffold_create
  end
  
  def edit
    aquatic_activity = AquaticActivityEvent.find params[:id], :include => :aquatic_activity_code
    activity_name = aquatic_activity.aquatic_activity_code.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'edit', 
      :aquatic_activity_id => aquatic_activity.id, :aquatic_site_id => aquatic_activity.aquatic_site_id
  end
  
  def show
    aquatic_activity = AquaticActivityEvent.find params[:id], :include => :aquatic_activity_code
    activity_name = aquatic_activity.aquatic_activity_code.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'show', 
      :aquatic_activity_id => aquatic_activity.id, :aquatic_site_id => aquatic_activity.aquatic_site_id
  end
  
  def aquatic_site_activities    
    @label = params[:label]       
    @constraints = { :aquaticsiteid => params[:aquatic_site_id], :aquaticactivitycd => params[:aquatic_activity_code] }  
    render :layout => false
  end
  
  def aquatic_activity_details
    @record = AquaticActivityEvent.find params[:aquatic_activity_id]
    render :action => 'show', :layout => false
  end
  
  def before_create_save(record)
    record.aquaticsiteid = active_scaffold_session_storage[:constraints][:aquaticsiteid]
    record.aquaticactivitycd = active_scaffold_session_storage[:constraints][:aquaticactivitycd]
    record.agencycd = current_user.agency.code
  end
end
