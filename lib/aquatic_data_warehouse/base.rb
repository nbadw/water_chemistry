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
        original_name = super
        adw_name = "#{adw_prefix}#{original_name.singularize.camelize}"
        set_table_name(adw_name)
        adw_name
      end
    end
  end
end
