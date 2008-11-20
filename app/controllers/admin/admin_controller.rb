module Admin
  class AdminController < ApplicationController 
    layout 'admin'
    before_filter :login_required, :set_code_tables, :set_title
    
    def current_location
      'Administration'
    end
    
    def navigation_tabs_partial
      'admin/navigation_tabs'
    end
    
    def index
      render :template => 'admin/index'
    end
    
    private
    def authorized?
      logged_in? && current_user.admin
    end
    
    def set_title
      @title = active_scaffold_config ? active_scaffold_config.label : 'Home'
    end
    
    def set_code_tables
      @code_tables = [:agencies, :aquatic_activities, :aquatic_activity_methods, :instruments,
        :observable_values, :qualifiers, :sample_collection_methods, :users,
        :water_sources, :measurements, :observations, :units_of_measure].sort_by { |sym| sym.to_s } 
    end
  end
end
