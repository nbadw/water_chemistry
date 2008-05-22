module DataWarehouse    
  module ActsAsImportable
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_importable(import_table = nil, options = {})
        unless acts_as_importable? # don't let AR call this twice
          cattr_accessor :import_from_table, :import_primary_key, :import_overwrite_existing,
            :import_perform_validations, :import_must_import_all_or_fail, :import_column_prefix
          self.import_from_table = import_table
          self.import_primary_key = options[:primary_key] || guess_primary_key(import_table)
          self.import_perform_validations = options[:perform_validations] || true
          self.import_must_import_all_or_fail = options[:must_import_all_or_fail] || true
          self.import_overwrite_existing = options[:overwrite_existing] || false
          self.import_column_prefix = options[:column_prefix]
          include ImportMethods
        end
      end

      def acts_as_importable?
        self.included_modules.include?(ImportMethods)
      end
      
      def guess_primary_key(table_name)
        if /^tbl(.+)/.match(table_name)
          primary_key = "#{table_name[3..-1]}Id"
        elsif /^cd(.+)/.match(table_name)
          primary_key = "#{table_name[2..-1]}Cd"
        else
          primary_key = 'Id'
        end
        primary_key
      end
      
      def guess_target_attribute(target_attribute, possible_attributes, prefix = nil)
        weighted_levenshtein_distances = possible_attributes.collect do |possible_attribute|
          word1 = target_attribute.gsub('_', '').downcase
          word2 = possible_attribute.gsub('_', '').downcase
          word1.gsub!(prefix.downcase, '') if prefix
          word2.gsub!(prefix.downcase, '') if prefix
          distance = Text::Levenshtein.distance(word1, word2)        
          { :attribute => possible_attribute, :weight => (word1.length - distance).abs.to_f / word1.length.to_f }
        end
        weighted_levenshtein_distances.sort{ |a,b| a[:weight] <=> b[:weight] }.last[:attribute]
      end
    end
    
    # These ImportMethods are the methods added to the model class.  The methods directly under ImportMethods are instance methods.
    module ImportMethods
      def self.included(base) 
        base.extend ClassMethods
      end

      # These are class methods that are mixed in with the model class.
      module ClassMethods        
        attr_accessor :import_transformers
              
        def import_transformation_for(original_column, target_column = nil, &block)          
          self.import_transformers ||= {}                    
          original_column.downcase!
          raise ArgumentError, "an import transformation for attribute [#{original_column}] has already been specified" if self.import_transformers[original_column]          
          self.import_transformers[original_column] = { :target_column => target_column || original_column, :block => block }
        end
        
        def import_from_data_warehouse    
          data_warehouse_configurations = YAML::load_file("#{RAILS_ROOT}/config/data_warehouse.yml")          
          
          logger.debug 'connecting to data warehouse'                   
          ActiveRecord::Base.establish_connection(data_warehouse_configurations["#{RAILS_ENV}"])    

          table_name = self.import_from_table
          primary_key = self.import_primary_key
          logger.debug "reading data from #{table_name}"      
          dw_table = Class.new(ActiveRecord::Base) do
            set_table_name  table_name.downcase
            set_primary_key primary_key.downcase if primary_key
          end  
          
          columns = dw_table.columns.inject(Hash.new) { |hash, col| hash.merge({col.name => col}) }
          logger.debug "column info: #{dw_table.columns.inspect}"
          
          records = dw_table.find :all                
          logger.debug "#{records.size} records ready to be imported" 
          
          logger.debug 'restoring default active record connection'
          ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])  
                  
          logger.debug 'transforming records for import'
          import_values = records.collect do |record|
            attributes = {}
            record.attributes.each do |attribute, value|                            
              if transformer = self.import_transformers[attribute]
                block = transformer[:block]
                attributes[transformer[:target_column]] = block ? block.call(attribute, value, columns[attribute]) : value
              else
                target_columns = self.columns.collect{ |col| col.name }
                guessed_attribute = guess_target_attribute(attribute, target_columns, self.import_column_prefix)
                attributes[guessed_attribute] = value
              end
            end
            attributes[:id] = record.id
            attributes
          end     
            
          import_values.each_with_index do |attributes, i|
            logger.debug "importing #{self.class_name} record #{i+1} of #{records.size}"
            begin
              new_record = self.new(attributes)
              new_record.id = attributes[:id]
              new_record.save(self.import_perform_validations)
            rescue Exception => exc
              logger.error "IMPORT ERROR: #{exc.message} - #{attributes.inspect}"
            end
          end        
        end
      end # ClassMethods    
    end # ImportMethods
  end # ActsAsImportable
end # DataWarehouse