module AquaticDataWarehouse
  module Validations
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def validates_location(*attr_names)
        configuration = {}
        configuration.update(attr_names.extract_options!)
        
        validates_each(attr_names, configuration) do |record, attr_name, value|
          aggregation = reflect_on_aggregation(attr_name)               
          raise 'validates_location only works on attribute aggregations that compose Location objects' unless aggregation && value.is_a?(Location)
          
          unless value.valid?
            # copy location errors to active record
            aggregation.options[:mapping].each do |mapping|
              attr, location_attr = mapping
              value.errors.on(location_attr).to_a.each do |error|
                record.errors.add(attr, error)
              end              
            end            
          end         
        end
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
            condition_sql = "#{record.class.quoted_table_name}.#{column.name} #{attribute_condition(value)}"
            condition_params = [value]
          else
            # sqlite has case sensitive SELECT query, while MySQL/Postgresql don't.
            # Hence, this is needed only for sqlite.
            condition_sql = "LOWER(#{record.class.quoted_table_name}.#{column.name}) #{attribute_condition(value)}"
            condition_params = [value.downcase]
          end

          if scope = configuration[:scope]
            Array(scope).map do |scope_item|
              scope_column = record.column_for_attribute(scope_item)
              scope_value = record.send(scope_item)
              condition_sql << " AND #{record.class.quoted_table_name}.#{scope_column.name} #{attribute_condition(scope_value)}"
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
                :select     => "#{connection.quote_column_name(column.name)}",
                :from       => "#{finder_class.quoted_table_name}",
                :conditions => [condition_sql, *condition_params]
              )
            )
          end

          unless results.length.zero?
            found = true

            # As MySQL/Postgres don't have case sensitive SELECT queries, we try to find duplicate
            # column in ruby when case sensitive option
            if configuration[:case_sensitive] && column.text?
              found = results.any? { |a| a[column.name.to_s] == value }
            end

            record.errors.add(attr_name, configuration[:message]) if found
          end
        end
      end
      
      def validates_numericality_of(*attr_names)
        configuration = { :on => :save, :only_integer => false, :allow_nil => false }
        configuration.update(attr_names.extract_options!)

        numericality_options = ActiveRecord::Validations::ClassMethods::ALL_NUMERICALITY_CHECKS.keys & configuration.keys

        (numericality_options - [ :odd, :even ]).each do |option|
          raise ArgumentError, ":#{option} must be a number" unless configuration[option].is_a?(Numeric)
        end

        validates_each(attr_names,configuration) do |record, attr_name, value|
          col_name = record.column_for_attribute(attr_name).name
          raw_value = record.send("#{col_name}_before_type_cast") || value

          next if configuration[:allow_nil] and raw_value.nil?

          if configuration[:only_integer]
            unless raw_value.to_s =~ /\A[+-]?\d+\Z/
              record.errors.add(attr_name, configuration[:message] || ActiveRecord::Errors.default_error_messages[:not_a_number])
              next
            end
            raw_value = raw_value.to_i
          else
            begin
              raw_value = Kernel.Float(raw_value.to_s)
            rescue ArgumentError, TypeError
              record.errors.add(attr_name, configuration[:message] || ActiveRecord::Errors.default_error_messages[:not_a_number])
              next
            end
          end

          numericality_options.each do |option|
            case option
            when :odd, :even
              record.errors.add(attr_name, configuration[:message] || ActiveRecord::Errors.default_error_messages[option]) unless raw_value.to_i.method(ALL_NUMERICALITY_CHECKS[option])[]
            else
              message = configuration[:message] || ActiveRecord::Errors.default_error_messages[option]
              message = message % configuration[option] if configuration[option]
              record.errors.add(attr_name, message) unless raw_value.method(ActiveRecord::Validations::ClassMethods::ALL_NUMERICALITY_CHECKS[option])[configuration[option]]
            end
          end
        end
      end
      
    end
  end
end
