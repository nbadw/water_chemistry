class ActivitiesController < ApplicationController
  active_scaffold :activity do |config|
    config.columns = [:name, :category, :duration]    
  end
  
  def new
    @activity_groups = Activity.group_by_category :all
    @activity_groups.each{ |group, activities| activities.sort!{ |a, b| a.name <=> b.name } }
    @groups = @activity_groups.collect{ |group, activities| group }.sort
    render :layout => false
  end
end