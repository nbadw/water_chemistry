# 
# To change this template, choose Tools | Templates
# and open the template in the editor.


module AquaticDataWarehouse
  class Schema < ActiveRecord::Migration
    private_class_method :new
    
    class << self
      def install              
        Dir.mkdir(schema_dir) unless File.exists?(schema_dir)
        puts "generating schema load script"
        generate_schema_load_script
        puts "creating aquatic data warehouse database"  
        create_database      
        puts "populating tables"
        import_data
        puts "generating schema drop script"
        generate_schema_drop_script
      end
    
      def uninstall
        puts "removing aquatic data warehouse database"
        remove_database
        File.delete(schema_load_file)
        File.delete(schema_drop_file)
      end
    
      def installed?
        File.exists?(schema_load_file) && File.exists?(schema_drop_file)
      end
    
      private
      def import_data
        puts "XXX"
      end
      
      def create_database
        ActiveRecord::Base.establish_connection
        load(schema_load_file)
      end
      
      def remove_database
        ActiveRecord::Base.establish_connection
        load(schema_drop_file)
      end
      
      def schema_dir
        File.join(RAILS_ROOT, 'db', 'aquatic_data_warehouse')
      end
    
      def schema_load_file
        File.join(schema_dir, 'schema_load.rb')
      end
    
      def schema_drop_file
        File.join(schema_dir, 'schema_drop.rb')
      end
    
      def generate_schema_load_script
        File.open(schema_load_file, 'w+') do |f|
          f << "ActiveRecord::Schema.define() do\n"
          tables.each { |table| write table, f }
          f << "end"
        end
      end
    
      def generate_schema_drop_script
        File.open(schema_drop_file, 'w+') do |f|
          f << "ActiveRecord::Schema.define() do\n"
          tables.each do |table_name|
            f << "  drop_table \"#{table_name}\"\n"
          end
          f << "end"
        end
      end
    
      def write(table_name, file)  
        puts "* processing #{table_name}"
        columns = columns(table_name)
        
        file << "  create_table \"#{table_name}\""
        table_options(table_name, columns).each do |option, value|          
          write_option(file, option, value)
        end
        file << " do |t|\n"
              
        columns.each do |column|
          file << "    t.#{column.sql_type} \"#{column.name}\""
          column_options(column).each do |option, value|
            write_option(file, option, value)
          end
          file << "\n"
        end
      
        file << "  end\n\n"
        
        write_indexes(file, table_name)
        write_extra(file, table_name)
      end
      
      def write_indexes(file, table_name)
        
      end
      
      def write_extra(file, table_name)
        if table_name == 'cdAgency'
          file << '  execute "ALTER TABLE `cdAgency` ADD PRIMARY KEY (`AgencyCd`);"'
          file << "\n\n"
        end
        
        if table_name == 'tblDrainageUnit'
          file << 'execute "ALTER TABLE `tblDrainageUnit` ADD PRIMARY KEY (`DrainageCd`);"'
          file << "\n\n"
        end
      end
      
      def write_option(file, option, value)
        value = '"' + value + '"' if value.is_a?(String)
        file << ", :#{option} => #{value}"
      end
      
      def column_options(column)   
        options = {}
        options[:default] = column.default if column.default
        options[:null]    = false if !column.null
        options[:limit]   = column.limit if column.limit
        options
      end
      
      def table_options(table_name, columns)
        options = {}  
        if primary_key_name = primary_key_name(table_name, columns)  
          options[:primary_key] = primary_key_name
        else
          options[:id] = false
        end
        options
      end
    
      def primary_key_name(table_name, columns)
        # exceptions
        return nil if table_name == 'cdAgency' 
        
        exceptions = {          
          'cdAquaticActivityMethod' => 'AquaticMethodCd',
          'tblWaterMeasurement' => 'WaterMeasurementID',
          'tblObservations' => 'ObservationID',
          'tblAquaticSite' => 'AquaticSiteID',
          'tblAquaticSiteAgencyUse' => 'AquaticSiteUseID',
          'tblSiteMeasurement' => 'SiteMeasurementID',
          'tblEnvironmentalObservations' => 'EnvObservationID',
          'tblWaterBody' => 'WaterBodyID' 
        }
        
        if column_name = exceptions[table_name]
          primary_key_column = columns.find { |column| column.name == column_name }
        else
          primary_key_column = columns.find do |column|
            match = table_name.match(/(tbl|cd)(.*)/)
            base_name = match[2] if match
            (column.name == "#{base_name}Id" || column.name == "#{base_name}Cd") && column.sql_type == :integer
          end
        end
        
        if primary_key_column
          columns.delete(primary_key_column)
          primary_key_column.name
        end
      end
          
      def connection
        unless @connection 
          ActiveRecord::Base.establish_connection({
              :adapter => :ms_access,
              :database => 'db/nb_aquatic_data_warehouse.mdb'
            }) 
          @connection = ActiveRecord::Base.connection
        end
        @connection
      end
    
      def tables
        %w(
        cdAgency cdAquaticActivity cdAquaticActivityMethod tblWaterMeasurement cdInstrument cdMeasureInstrument cdMeasureUnit
        cdOandM cdOandMValues cdUnitofMeasure cdWaterChemistryQualifier cdWaterParameter cdWaterSource tblAquaticActivity tblObservations    
        tblAquaticSite tblAquaticSiteAgencyUse tblSiteMeasurement tblEnvironmentalObservations tblDrainageUnit tblWaterBody tblWaterChemistryAnalysis
        )
      end
    
      def columns(table)
        connection.columns(table)
      end
    end    
  end
end
