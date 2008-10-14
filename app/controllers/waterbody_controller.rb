class WaterbodyController < ApplicationController
  before_filter :login_required
  layout false
  
  def autocomplete    
    query = params[:waterbody][:search]
    @waterbodies = Waterbody.search(query) unless query.blank?
    render :partial => "autocomplete" 
  end
  
  def area_of_interest_autocomplete
    query = params[:waterbody][:search]
    @waterbodies = Waterbody.search(query) unless query.blank?
    render :partial => "area_of_interest_autocomplete_result"
  end
end
