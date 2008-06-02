  class TblAquaticActivityController < ApplicationController  
  active_scaffold :tbl_aquatic_activity do |config|
    # base config 
    config.label = "Aquatic Activities"
    config.columns = [:aquatic_activity_method_code, :start_date, :agency, :weather_conditions, :rain_fall_in_last_24_hours, :waterlevel]
      
    config.update.link.inline = false
    config.show.link.inline = false
  end
  
  def edit
    aquatic_activity = TblAquaticActivity.find params[:id], :include => :aquatic_activity_code
    activity_name = aquatic_activity.aquatic_activity_code.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'edit', :id => params[:id]
  end
  
  def show
    aquatic_activity = TblAquaticActivity.find params[:id], :include => :aquatic_activity_code
    activity_name = aquatic_activity.aquatic_activity_code.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'show', :id => params[:id]
  end
  
  def aquatic_site_activities    
    @label = params[:label]    
    @conditions = ["#{TblAquaticActivity.table_name}.aquaticsiteid = ? AND #{TblAquaticActivity.table_name}.aquaticactivitycd = ?", 
      params[:aquatic_site_id], params[:aquatic_activity_code]]
    
    render :layout => false
  end
end
