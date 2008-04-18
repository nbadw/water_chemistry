class ActivitiesController < ApplicationController
  def index
    @activities = Activity.find :all
  end
  
  def show
    @activity = Activity.find params[:id]
  end
end