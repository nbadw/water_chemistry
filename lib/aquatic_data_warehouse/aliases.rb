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
        
    def read_dw_attribute(attr_name)
      column = column_for_attribute(attr_name)
      read_attribute(column.name) if column
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
      
      def composed_of(part_id, options = {}, &block)
        options.assert_valid_keys(:class_name, :mapping, :allow_nil)

        name        = part_id.id2name
        class_name  = options[:class_name] || name.camelize
        mapping     = options[:mapping]    || [ name, name ]
        mapping     = [ mapping ] unless mapping.first.is_a?(Array)
        allow_nil   = options[:allow_nil]  || false

        reader_method(name, class_name, mapping, allow_nil)
        writer_method(name, class_name, mapping, allow_nil, block)
        
        create_reflection(:composed_of, part_id, options, self)
      end

      private
      
        def reader_method(name, class_name, mapping, allow_nil)
          module_eval do
            define_method(name) do |*args|
              force_reload = args.first || false
              if (instance_variable_get("@#{name}").nil? || force_reload) && (!allow_nil || mapping.any? {|pair| !read_dw_attribute(pair.first).nil? })
                instance_variable_set("@#{name}", class_name.constantize.new(*mapping.collect {|pair| read_dw_attribute(pair.first)} ))
              end
              instance_variable_get("@#{name}")
            end
          end
        end

        def writer_method(name, class_name, mapping, allow_nil, conversion)
          module_eval do
            define_method("#{name}=") do |part|
              if part.nil? && allow_nil
                mapping.each do |pair|
                  col = column_for_attribute(pair.first)
                  self[col.name] = nil if col
                end
                instance_variable_set("@#{name}", nil)
              else
                part = conversion.call(part) unless part.is_a?(class_name.constantize) || conversion.nil?
                mapping.each do |pair|
                  col = column_for_attribute(pair.first)
                  self[col.name] = part.send(pair.last) if col
                end
                instance_variable_set("@#{name}", part.freeze)
              end
            end
          end
        end
    end
  end
end
