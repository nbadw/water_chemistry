# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module AquaticDataWarehouse
  module Aliases
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def columns_hash
        @columns_hash ||= columns.inject({}) do |hash, column|
          hash[column.name.underscore] = column
          hash
        end     
      end
    end
  end
end
