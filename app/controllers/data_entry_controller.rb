class DataEntryController < ApplicationController
  layout 'application'
  before_filter :login_required
  
  def index
    redirect_to :action => 'browse'
  end
  
  def browse
    @activity_groups = Activity.group_by_category(:all)
    render :action => 'index'
  end
  
  def explore
    
  end
end
