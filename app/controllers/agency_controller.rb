class AgencyController < ApplicationController
  before_filter :login_required
  
  active_scaffold do |config| 
    config.label = :agency_label.l
    config.actions = [:list]

    config.columns = [:code, :name]
    config.columns[:code].label = :agency_code_label.l
    config.columns[:name].label = :agency_name_label.l
  end
end
