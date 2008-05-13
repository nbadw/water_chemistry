class DataEntryController < ApplicationController
  layout 'application'
  before_filter :login_required
    
  def browse    
  end
  
  def explore    
    render :layout => !request.xml_http_request?
  end
end
