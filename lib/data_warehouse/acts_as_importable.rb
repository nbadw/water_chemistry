module DataWarehouse    
  module ActsAsImportable
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_importable(import_table = nil, options = {})
        unless acts_as_importable? # don't let AR call this twice
          cattr_accessor :import_from_table, :import_primary_key, :import_overwrite_existing,
            :import_perform_validations, :import_must_import_all_or_fail, :import_column_prefix,
            :import_excludes, :import_log
          self.import_from_table = import_table
          self.import_primary_key = options[:primary_key] || guess_primary_key(import_table)
          self.import_perform_validations = false
          self.import_must_import_all_or_fail = options.has_key?(:must_import_all_or_fail) ? options[:must_import_all_or_fail] : true
          self.import_overwrite_existing = options.has_key?(:overwrite_existing) ? options[:overwrite_existing] : false
          self.import_column_prefix = options[:column_prefix]
          self.import_excludes = options[:exclude] || []
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
        return target_attribute if possible_attributes.include?(target_attribute)
        
        weighted_levenshtein_distances = possible_attributes.collect do |possible_attribute|
          word1 = target_attribute.gsub('_', '').downcase
          word2 = possible_attribute.gsub('_', '').downcase
          word1.gsub!(prefix.downcase, '') if prefix && word1.starts_with?(prefix)
          word2.gsub!(prefix.downcase, '') if prefix && word2.starts_with?(prefix)
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
        
        def run_import_transformations(attributes, columns)
          import_log = self.import_log
          transformers = self.import_transformers || {}
          
          self.import_excludes.each do |exclude|
            import_log.debug "excluding #{exclude}" if import_log.debug?
            attributes.delete(exclude.downcase)
          end
          
          new_attributes = {}
          attributes.each do |attribute, value| 
            next if attribute == self.import_primary_key.downcase # we'll set this last to make sure it doesn't get overwritten
                          
            if transformer = transformers[attribute]
              block  = transformer[:block]
              target = transformer[:target_column]
              new_attributes[target] = block ? block.call(attributes) : value
              import_log.debug "transform: #{attribute}=#{value} -> #{target}=#{new_attributes[target]}" if import_log.debug?
            else
              guessed_attribute = guess_target_attribute(attribute, columns, self.import_column_prefix)
              new_attributes[guessed_attribute] = value
              import_log.debug "transform guess: #{attribute}=#{value} -> #{guessed_attribute}=#{new_attributes[guessed_attribute]}" if import_log.debug?
            end               
          end

          new_attributes[self.primary_key] = attributes[self.primary_key]
          new_attributes
        end
        
        def import_from_data_warehouse                        
          import_log = self.import_log ||= Logger.new(File.open("#{RAILS_ROOT}/log/import_#{RAILS_ENV}.log", "a"))
          import_log.level = RAILS_ENV == 'production' ? Logger::INFO : Logger::DEBUG
          data_warehouse_configurations = YAML::load_file("#{RAILS_ROOT}/config/data_warehouse.yml")                    
          
          import_log.debug 'connecting to data warehouse'                   
          ActiveRecord::Base.establish_connection(data_warehouse_configurations["#{RAILS_ENV}"])    

          table_name = self.import_from_table
          primary_key = self.import_primary_key
          import_log.info "reading data from #{table_name}"      
          puts "reading data from #{table_name}"  
          dw_table = Class.new(ActiveRecord::Base) do
            set_table_name  table_name.downcase
            set_primary_key primary_key.downcase if primary_key
          end  
                 
          total_records = dw_table.count
          if total_records == 0
            import_log.info "table is empty - nothing to import"
            puts "table is empty - nothing to import"
            return
          end
          
          limit = 1000
          pages = (total_records / limit) + 1          
          ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV]) 
          columns = self.columns.collect{ |column| column.name } 
          
          pages.times do |page|
            ActiveRecord::Base.establish_connection(data_warehouse_configurations["#{RAILS_ENV}"])
            
            records = dw_table.find :all, :limit => limit, :offset => page * limit             
            records.collect! do |record|                 
              attributes = record.attributes
              attributes[self.primary_key] = record.id
              attributes
            end
            import_log.info "preparing records #{page * limit + 1}-#{page * limit + limit} (of #{total_records}) for import"
            puts "preparing records #{page * limit + 1}-#{page * limit + limit} (of #{total_records}) for import"

            records.collect! do |attributes|              
              attributes = run_import_transformations(attributes, columns)            
              attributes['created_at'] = DateTime.now if columns.include?('created_at')
              attributes['updated_at'] = DateTime.now if columns.include?('updated_at')
              columns.collect { |col| attributes[col] }
            end

            import_log.info 'performing bulk import'
            puts 'performing bulk import'
            ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV]) 
            self.import columns, records, { :validate => false }
          end
          import_log.info "import of #{table_name} complete"
          puts "import of #{table_name} complete"
          import_log.debug 'restoring default active record connection' if import_log.debug?
          ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])  
        end
      end # ClassMethods    
    end # ImportMethods
  end # ActsAsImportable
end # DataWarehouse