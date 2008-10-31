class WaterbodyController < ApplicationController
  layout false
  
  def waterbody_autocomplete    
    query = params[:waterbody][:search]
    @waterbodies = Waterbody.search(query) unless query.blank?
    render :partial => "waterbody_autocomplete_result" 
  end
  
  def area_of_interest_autocomplete
    query = params[:waterbody][:search]
    @waterbodies = Waterbody.search(query) unless query.blank?
    distinct = {}
    @waterbodies.each{ |waterbody| distinct[waterbody.drainage_cd] = waterbody }
    @waterbodies = distinct.values.sort { |a, b| a.drainage_cd <=> b.drainage_cd }
    render :partial => "area_of_interest_autocomplete_result"
  end
end
