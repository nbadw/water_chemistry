class AquaticActivitiesController < ApplicationController
  layout 'admin'
  active_scaffold :aquatic_activities do |config|
    config.update.link.inline = false
    config.show.link.inline = false
  end
  
  def edit
    aquatic_activity = AquaticActivity.find params[:id], :include => :aquatic_activity_code
    activity_name = aquatic_activity.aquatic_activity_code.activity
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :id => params[:id]
  end
  
  def site_aquatic_activities    
    @aquatic_site_id = params[:aquatic_site_id]
    @activity_id = params[:activity_id]
    @label = params[:label]
    render :layout => false
  end
end
