module DataWarehouse    
  module ActsAsImportable
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_importable(options = {})
        unless acts_as_importable? # don't let AR call this twice
          cattr_accessor :import_overwrite_existing, :import_perform_validations, 
            :import_must_import_all_or_fail, :import_log
          self.import_perform_validations = false
          self.import_must_import_all_or_fail = options.has_key?(:must_import_all_or_fail) ? options[:must_import_all_or_fail] : true
          self.import_overwrite_existing = options.has_key?(:overwrite_existing) ? options[:overwrite_existing] : false
          include ImportMethods
        end
      end

      def acts_as_importable?
        self.included_modules.include?(ImportMethods)
      end
    end
    
    # These ImportMethods are the methods added to the model class.  The methods directly under ImportMethods are instance methods.
    module ImportMethods
      def self.included(base) 
        base.extend ClassMethods
      end

      # These are class methods that are mixed in with the model class.
      module ClassMethods     
        def import_from_data_warehouse                        
          import_log = self.import_log ||= Logger.new(File.open("#{RAILS_ROOT}/log/import_#{RAILS_ENV}.log", "a"))
          import_log.level = RAILS_ENV == 'production' ? Logger::INFO : Logger::DEBUG
          data_warehouse_configurations = YAML::load_file("#{RAILS_ROOT}/config/data_warehouse.yml")                    
          
          import_log.debug 'connecting to data warehouse'                   
          ActiveRecord::Base.establish_connection(data_warehouse_configurations["#{RAILS_ENV}"])    
                    
          total_records = self.count :all
          if total_records == 0
            import_log.info "table is empty - nothing to import"
            puts "table is empty - nothing to import"
            return
          end
          
          limit = 1000
          pages = total_records / 1000 + 1
          pages.times do |page|
            unless page == 0
              import_log.debug 'connecting to data warehouse'                   
              ActiveRecord::Base.establish_connection(data_warehouse_configurations["#{RAILS_ENV}"])    
            end
            
            if pages > 1              
              import_log.info "reading rows #{page * limit + 1}-#{(page + 1) * limit} of #{total_records} from #{table_name}"   
              puts "reading rows #{page * limit + 1}-#{(page + 1) * limit} of #{total_records} from #{table_name}" 
            else
              import_log.info "reading data from #{table_name}"      
              puts "reading data from #{table_name}" 
            end
            columns = self.columns.collect{ |col| col.name } 
            records = self.paginate(:all, :page => (page+1), :per_page => limit).collect do |row|
              columns.collect { |col| row.attributes[col] } 
            end
            
            import_log.debug 'restoring default active record connection' if import_log.debug?
            ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])  
          
            import_log.info 'performing bulk import'
            puts 'performing bulk import'
            self.import columns, records, { :validate => false, :on_duplicate_key_update => columns }            
          end          
            
          import_log.info "import of #{table_name} complete"
          puts "import of #{table_name} complete"
        end
      end # ClassMethods    
    end # ImportMethods
  end # ActsAsImportable
end # DataWarehouse