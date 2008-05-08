class AquaticSitesController < ApplicationController
  layout 'admin'
  active_scaffold :aquatic_site do |config|
    #config.columns = [:id, :agency, :watershed, :description]
    #config.create.columns = [:name, :description] # waterbody is mandatory
    #config.show.columns = [:id, :name] # rest from data entry
  end
end
