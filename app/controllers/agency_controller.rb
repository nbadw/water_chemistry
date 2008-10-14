class AgencyController < ApplicationController
  before_filter :login_required
  
  active_scaffold do |config| 
    config.label = "Agencies"
    config.actions = [:list]
    config.columns = [:code, :name, :agency_type]
    config.columns[:code].label = 'Agency Code'
    config.columns[:agency_type].label = 'Agency Type'
  end
end
