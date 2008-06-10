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
      sampling_info.add :start_date, :aquatic_activity_method_code, :crew, :agency, :aquatic_activity_code
      sampling_info.columns[:aquatic_activity_method_code].label = "Collection Method"
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
  
  def edit
    aquatic_activity = TblAquaticActivity.find params[:id], :include => :aquatic_activity_code
    activity_name = aquatic_activity.aquatic_activity_code.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'edit', 
      :id => aquatic_activity.id, :aquatic_site_id => aquatic_activity.aquatic_site_id
  end
  
  def show
    aquatic_activity = TblAquaticActivity.find params[:id], :include => :aquatic_activity_code
    activity_name = aquatic_activity.aquatic_activity_code.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'show', 
      :id => aquatic_activity.id, :aquatic_site_id => aquatic_activity.aquatic_site_id
  end
  
  def aquatic_site_activities    
    @label = params[:label]    
    @conditions = ["#{TblAquaticActivity.table_name}.aquaticsiteid = ? AND #{TblAquaticActivity.table_name}.aquaticactivitycd = ?", 
      params[:aquatic_site_id], params[:aquatic_activity_code]]    
    render :layout => false
  end
  
  def aquatic_activity_details
    @record = TblAquaticActivity.find params[:aquatic_activity_id]
    render :action => 'show', :layout => false
  end
end
