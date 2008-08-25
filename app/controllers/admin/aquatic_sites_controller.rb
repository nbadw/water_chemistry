module Admin
  class AquaticSitesController < ApplicationController 
    layout 'admin'
    active_scaffold :aquatic_site
  end
end
