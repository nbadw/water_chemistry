# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module AquaticDataWarehouse
  module Aliases
    def self.included(base)
      base.extend(ClassMethods)
    end
      
    def column_for_attribute(name)
      super(name.to_s.underscore)
    end
    
    module ClassMethods
      def columns_hash
        @columns_hash ||= columns.inject({}) do |hash, column|
          hash[column.name.underscore] = column
          hash
        end     
      end
      
      def column_for_attribute(name)
        columns_hash[name.to_s.underscore]
      end
      
      def define_read_method(symbol, attr_name, column)           
        cast_code = column.type_cast_code('v') if column
        access_code = cast_code ? "(v=@attributes['#{column.name}']) && #{cast_code}" : "@attributes['#{column.name}']"

        unless column.name.to_s == self.primary_key.to_s
          access_code = access_code.insert(0, "missing_attribute('#{column.name}', caller) unless @attributes.has_key?('#{column.name}'); ")
        end

        if cache_attribute?(column.name)
          access_code = "@attributes_cache['#{column.name}'] ||= (#{access_code})"
        end
        evaluate_attribute_method attr_name, "def #{symbol}; #{access_code}; end"
      end
      
      
      def define_write_method(attr_name)
        column = columns_hash[attr_name.to_s]
        evaluate_attribute_method attr_name, "def #{attr_name}=(new_value);write_attribute('#{column.name}', new_value);end", "#{attr_name}="
      end
    end
  end
end
