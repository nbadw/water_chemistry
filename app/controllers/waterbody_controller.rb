class WaterbodyController < ApplicationController
  layout false
  
  def autocomplete    
    query = params[:waterbody][:search]
    @waterbodies = Waterbody.search(query) unless query.blank?
    render :partial => "autocomplete" 
  end
  
  def explain_drainage_code
    
  end
end
