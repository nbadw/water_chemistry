class WatershedsController < ApplicationController
  before_filter :check_administrator_role, :only => [:create, :update, :destroy, :new, :edit]
  
  layout 'admin'
  active_scaffold
end
