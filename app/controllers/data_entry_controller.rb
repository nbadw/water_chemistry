class DataEntryController < ApplicationController
  layout 'application'
  before_filter :login_required
  
  def index
    redirect_to :action => 'overview'
  end
  
  def overview
  end
  
  def water_chemistry    
  end
end
