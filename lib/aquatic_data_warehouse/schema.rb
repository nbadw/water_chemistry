# 
# To change this template, choose Tools | Templates
# and open the template in the editor.


module AquaticDataWarehouse
  class Schema < ActiveRecord::Migration
    private_class_method :new
        
    def self.up
      data_tables.each do |table|
        columns = connection.columns(table)
        create table, columns
      end
    end
    
    def self.down
      data_tables.each do |table|
        drop table
      end
    end
    
    def self.create(table_name, columns)
      if table_name.match(/^tbl\w+$/) 
        primary_key = table_name[3..-1] + "Id"
      else
        primary_key = table_name[2..-1] + "Cd"
      end
      columns.delete_if { |column| column.name.downcase == primary_key.downcase }
      
      ActiveRecord::Base.establish_connection
      create_table table_name, :primary_key => primary_key do |t|
        columns.each do |column|
          t.column column.name, column.sql_type, { :default => column.default, :null => column.null, :limit => column.limit }          
        end
      end
    end
    
    def self.drop(table_name)
      ActiveRecord::Base.establish_connection
      drop_table table
    end
    
    def self.connection
      ActiveRecord::Base.establish_connection({
        :adapter => :ms_access,
        :database => 'db/nb_aquatic_data_warehouse.mdb'
      }) 
      ActiveRecord::Base.connection
    end
    
    def self.tables
      @tables ||= connection.tables
    end
    
    def self.data_tables
      tables.collect { |table| table if table.match(/^tbl\w+$/) }.compact
    end
    
    def self.code_tables
      tables.collect { |table| table if table.match(/^cd\w+$/)  }.compact
    end
  end
end
