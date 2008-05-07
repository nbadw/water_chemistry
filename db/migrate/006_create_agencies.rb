class CreateAgencies < ActiveRecord::Migration
  def self.up
    create_table :agencies do |t|
      t.string  :name
      t.string  :code
      t.string  :agency_type
      t.boolean :data_rules
      t.timestamps
    end
    
    records = read_records_from_data_warehouse  
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
    records.each_with_index do |record, i|   
      puts "importing record #{i+1} of #{records.size}"
      import(record)
    end
  end

  def self.down
    drop_table :agencies
  end
  
  class DwAgency < ActiveRecord::Base
    set_table_name  'cdAgency'
    set_primary_key 'agencycd'
  end
  
  class Agency < ActiveRecord::Base    
  end
  
  def self.read_records_from_data_warehouse
    puts 'connecting to datawarehouse'
    # create an active record connection to the sqlserver database
    ActiveRecord::Base.establish_connection({
        'adapter' => 'sqlserver', 
        'database' => 'dataWarehouse_dev',
        'host' => '.\SQLEXPRESS',
        'provider' => 'SQLNCLI',
        'windows_auth' => true 
      })    
    require "#{RAILS_ROOT}/lib/sqlserver_adapter"    
    puts "reading data from #{DwAgency.table_name}"
    records = DwAgency.find :all
    puts "#{records.size} records ready for import"   
    records.collect { |record| record.attributes }
  end
  
  def self.import(attributes)
    begin      
      record = Agency.new
      record.name = attributes['agency']
      record.code = attributes['agencycd']
      record.agency_type = attributes['agencytype']
      record.data_rules = attributes['datarulesind'] == 'Y' ? true : false
      record.save!
    rescue Exception => exc
      puts "IMPORT ERROR: #{exc.message} - #{attributes.inspect}"
    end
  end
end
