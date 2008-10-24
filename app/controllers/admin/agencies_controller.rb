module Admin  
  class AgenciesController < AdminController 
    active_scaffold :agency do |config|
      config.columns = [:agency_cd, :agency, :agency_type, :data_rules_ind, :users]
      config.list.columns = [:agency_cd, :agency, :agency_type, :data_rules_ind, :users]
      config.create.columns = [:agency_cd, :agency, :agency_type, :data_rules_ind]
      config.update.columns = [:agency_cd, :agency, :agency_type, :data_rules_ind]
    end
  end
end
