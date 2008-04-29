class DataEntryController < ApplicationController
  layout 'application'
  before_filter :login_required
  
  def index
    redirect_to :action => 'overview'
  end
  
  def overview
    @user = self.current_user
    @agency = @user.agency
    @activities = Activity.find_by_agency @agency.id
  end
end
