# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module AquaticDataWarehouse
  class Base < ActiveRecord::Base
    self.abstract_class = true
      
    class << self      
      def adw_prefix
        nil # Please implement this in subclasses!!!
      end
      
      def get_primary_key(base_name) #:nodoc:
        "#{base_name}Id"
      end
      
      def reset_table_name        
        name = super
        # STI subclasses always use their superclass' table.
        name = "#{adw_prefix}#{name.singularize.camelize}" if self == base_class
        set_table_name(name)
        name
      end      
    end
        
    before_create :log_creating_user
    before_update :log_updating_user
    
    protected
    def log_creating_user
      current_user = self.current_user
      unless current_user.nil? || current_user == :false
        self.created_by  = current_user.send(:id)
      end
    end
    
    def log_updating_user
      current_user = self.current_user
      unless current_user.nil? || current_user == :false
        self.updated_by  = current_user.send(:id)
      end
    end
  end
end
