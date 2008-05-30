  class TblAquaticActivityController < ApplicationController  
  active_scaffold :tbl_aquatic_activity do |config|
    # base config 
    config.label = "Aquatic Activities"
    config.columns = [:comments, :crew, :weather_conditions, :aquatic_activity_method_code, :start_date, :end_date]
      
    config.update.link.inline = false
    config.show.link.inline = false
  end
  
  def edit
    aquatic_activity = TblAquaticActivity.find params[:id], :include => :aquatic_activity_code
    activity_name = aquatic_activity.aquatic_activity_code.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :id => params[:id]
  end
  
  def site_aquatic_activities
    @aquatic_site_id = params[:aquatic_site_id]
    @aquatic_activity_code = params[:aquatic_activity_code]
    @label = params[:label]
    render :layout => false
  end
end
