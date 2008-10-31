class AgencyController < ApplicationController
  before_filter :login_required
  
  active_scaffold do |config| 
    config.label = "Agencies"
    config.actions = [:list]
    config.columns = [:code, :name]
    config.columns[:code].label = 'Agency Code'
  end
end
