# 
# To change this template, choose Tools | Templates
# and open the template in the editor.


module AquaticDataWarehouse
  module Generators
    class SchemaGenerator < Rails::Generator::Base
      attr_reader :root_dir
      attr_reader :tables_hash

      def initialize(*args)
        raise 'Expecting a hash of tables to columns' unless args.first.is_a?(Hash)
        #super(*args)        

        # Derive source and destination paths.
        @source_root = options[:source] || File.join(spec.path, 'templates')
        if options[:destination]
          @destination_root = options[:destination]
        elsif defined? ::RAILS_ROOT
          @destination_root = ::RAILS_ROOT
        end

        # Silence the logger if requested.
        logger.quiet = options[:quiet]
        
        @tables_hash = args.first
        @root_dir = 'db/aquatic_data_warehouse'        
      end
  
      def manifest
        record do |m|
          m.directory root_dir
          m.template 'load_adw_database.rhtml', File.join(root_dir, 'load_adw_database.rb')
          m.template 'drop_adw_database.rhtml', File.join(root_dir, 'drop_adw_database.rb')          
        end
      end  
    end
  end
end
