class AgencyController < ApplicationController
  active_scaffold do |config| 
    config.label = "Agencies"
    config.actions.exclude :search
    config.columns = [:code, :name, :agency_type]
    config.columns[:code].label = 'Agency Code'
    config.columns[:agency_type].label = 'Agency Type'
  end
end
