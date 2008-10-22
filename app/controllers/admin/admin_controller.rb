module Admin
  class AdminController < ApplicationController 
    layout 'admin'
    before_filter :login_required, :set_code_tables, :set_title
    
    def index
      render :layout => 'admin', :inline => 'Please select a code table to administer.'
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
