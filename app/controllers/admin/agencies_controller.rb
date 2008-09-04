module Admin
  class AgenciesController < ApplicationController 
    layout 'admin'
    active_scaffold :agency
  end
end
