class ActiveAgencyController < ApplicationController  
  active_scaffold :agency
    
  def conditions_for_collection
    ["#{Agency.table_name}.#{Agency.primary_key} = ?", current_user.agency_id]
  end
end
