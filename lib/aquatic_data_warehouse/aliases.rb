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
    
    def validates_uniqueness_of(*attr_names)
      configuration = { :message => ActiveRecord::Errors.default_error_messages[:taken], :case_sensitive => true }
      configuration.update(attr_names.extract_options!)

      validates_each(attr_names,configuration) do |record, attr_name, value|
        # The check for an existing value should be run from a class that
        # isn't abstract. This means working down from the current class
        # (self), to the first non-abstract class. Since classes don't know
        # their subclasses, we have to build the hierarchy between self and
        # the record's class.
        class_hierarchy = [record.class]
        while class_hierarchy.first != self
          class_hierarchy.insert(0, class_hierarchy.first.superclass)
        end

        # Now we can work our way down the tree to the first non-abstract
        # class (which has a database table to query from).
        finder_class = class_hierarchy.detect { |klass| !klass.abstract_class? }

        column = record.column_for_attribute(attr_name)
        if value.nil? || (configuration[:case_sensitive] || !finder_class.columns_hash[attr_name.to_s].text?)
          condition_sql = "#{record.class.quoted_table_name}.#{attr_name} #{attribute_condition(value)}"
          condition_params = [value]
        else
          # sqlite has case sensitive SELECT query, while MySQL/Postgresql don't.
          # Hence, this is needed only for sqlite.
          condition_sql = "LOWER(#{record.class.quoted_table_name}.#{attr_name}) #{attribute_condition(value)}"
          condition_params = [value.downcase]
        end

        if scope = configuration[:scope]
          Array(scope).map do |scope_item|
            scope_value = record.send(scope_item)
            condition_sql << " AND #{record.class.quoted_table_name}.#{scope_item} #{attribute_condition(scope_value)}"
            condition_params << scope_value
          end
        end

        unless record.new_record?
          condition_sql << " AND #{record.class.quoted_table_name}.#{record.class.primary_key} <> ?"
          condition_params << record.send(:id)
        end

        results = finder_class.with_exclusive_scope do
          connection.select_all(
            construct_finder_sql(
              :select     => "#{connection.quote_column_name(attr_name)}",
              :from       => "#{finder_class.quoted_table_name}",
              :conditions => [condition_sql, *condition_params]
            )
          )
        end

        unless results.length.zero?
          found = true

          # As MySQL/Postgres don't have case sensitive SELECT queries, we try to find duplicate
          # column in ruby when case sensitive option
          if configuration[:case_sensitive] && finder_class.columns_hash[attr_name.to_s].text?
            found = results.any? { |a| a[attr_name.to_s] == value }
          end

          record.errors.add(attr_name, configuration[:message]) if found
        end
      end
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
