class CdAgencyController < ApplicationController
  active_scaffold do |config| 
    config.label = "Agencies"
    config.columns = [:agency, :agencytype]
    config.columns[:agency].label = 'Name'
    config.columns[:agencytype].label = 'Agency Type'
  end
end
