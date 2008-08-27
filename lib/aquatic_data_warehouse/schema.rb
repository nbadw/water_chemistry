# 
# To change this template, choose Tools | Templates
# and open the template in the editor.


module AquaticDataWarehouse
  class Schema < ActiveRecord::Migration
    private_class_method :new
            
    def self.define(&block)
      instance_eval(&block)
    end
    
    def self.install
      unless File.exists?(schema_dir)
        Dir.mkdir(schema_dir)
      end
      puts "generating schema load script"
      generate_schema_load_script
      puts "generating schema drop script"
      generate_schema_drop_script
      puts "creating aquatic data warehouse database"  
      ActiveRecord::Base.establish_connection
      load(schema_load_file)
    end
    
    def self.uninstall
      puts "removing aquatic data warehouse database"
      load(schema_drop_file)  
      File.delete(schema_load_file)
      File.delete(schema_drop_file)
    end
    
    def self.installed?
      File.exists?(schema_load_file) && File.exists?(schema_drop_file)
    end
    
    private
    def self.schema_dir
      File.join(RAILS_ROOT, 'db', 'aquatic_data_warehouse')
    end
    
    def self.schema_load_file
      File.join(schema_dir, 'schema_load.rb')
    end
    
    def self.schema_drop_file
      File.join(schema_dir, 'schema_drop.rb')
    end
    
    def self.generate_schema_load_script
      File.open(schema_load_file, 'w+') do |f|
        f << "AquaticDataWarehouse::Schema.define do\n"
        tables.each { |table| write table, f }
        f << "end"
      end
    end
    
    def self.generate_schema_drop_script
      File.open(schema_drop_file, 'w+') do |f|
        f << "AquaticDataWarehouse::Schema.define do\n"
        tables.each do |table_name|
          f << "  drop_table \"#{table_name}\"\n"
        end
        f << "end"
      end
    end
    
    def self.write(table_name, file)  
      puts "* processing #{table_name}"
      columns = columns(table_name)
      primary_key = columns.find do |column|
        root = table_root(table_name)
        column.name == "#{root}Id" || column.name == "#{root}Cd"
      end
            
      if primary_key
        columns.delete(primary_key)
        id_option = :primary_key
        id_value  = '"' + primary_key.name + '"'
      else
        id_option = :id
        id_value  = false
      end
      
      file << "  create_table \"#{table_name}\", :#{id_option} => #{id_value} do |t|\n"
      
      columns.each do |column|
        options = {}
        options[:default] = column.default if column.default
        options[:null]    = false if !column.null
        options[:limit]   = column.limit if column.limit
        file << "    t.#{column.sql_type} \"#{column.name}\""
        options.each do |option, value|
          file << ", :#{option} => #{value}"
        end
        file << "\n"
      end
      
      file << "  end\n\n"
    end
    
    def self.table_root(table_name)
      table_name.match(/(tbl|cd)(.*)/)
      $2
    end
    
    def self.create(table_name, columns)      
    end
    
    def self.drop(table_name)
    end
    
    def self.connection
      unless @connection 
        ActiveRecord::Base.establish_connection({
            :adapter => :ms_access,
            :database => 'db/nb_aquatic_data_warehouse.mdb'
          }) 
        @connection = ActiveRecord::Base.connection
      end
      @connection
    end
    
    def self.tables
      %w(
        cdAgency cdAquaticActivity cdAquaticActivityMethod tblWaterMeasurement cdInstrument cdMeasureInstrument cdMeasureUnit
        cdOandM cdOandMValues cdUnitofMeasure cdWaterChemistryQualifier cdWaterParameter cdWaterSource tblAquaticActivity tblObservations    
        tblAquaticSite tblAquaticSiteAgencyUse tblSiteMeasurement tblEnvironmentalObservations tblDraingeUnit tblWaterBody tblWaterChemistryAnalysis
      )
    end
    
    def self.columns(table)
      connection.columns(table)
    end
  end
end
