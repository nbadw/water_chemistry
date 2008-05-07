class CreateWaterbodies < ActiveRecord::Migration
  class DwWaterbody < ActiveRecord::Base
    set_table_name  'tblWaterBody'
    set_primary_key 'waterbodyid'
  end
  
  class Waterbody < ActiveRecord::Base    
  end
  
  def self.up
    create_table :waterbodies do |t|
      t.integer 'dw_waterbody_id'
      t.string  'name'
      t.string  'abbrev_name'
      t.string  'alt_name' 
      t.string  'waterbody_type'
      t.integer 'waterbody_complex_id'
      t.boolean 'surveyed'
      t.integer 'flows_into_waterbody_id'
      t.string  'flows_into_waterbody_name'
      t.string  'flows_into_watershed'
      t.timestamp 'date_entered'
      t.timestamp 'date_modified'
      t.timestamps
    end    
    
    records = read_waterbodies_from_data_warehouse    
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
    records.each_with_index do |record, i|
      puts "importing record #{i+1} of #{records.size}"
      import(record)
    end
  end

  def self.down
    drop_table :waterbodies
  end
  
  def self.read_waterbodies_from_data_warehouse
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
    puts 'reading data from tblWaterBody'
    records = DwWaterbody.find :all
    puts "#{records.size} records ready for import"   
    records.collect { |record| record.attributes }
  end
  
  def self.import(record)
    begin
      waterbody = Waterbody.new
      waterbody.dw_waterbody_id = record['waterbodyid']
      waterbody.name = record['waterbodyname']
      waterbody.abbrev_name = record['waterbodyname_abrev']
      waterbody.alt_name = record['waterbodyname_alt']
      waterbody.waterbody_type = record['waterbodytypecd']
      waterbody.waterbody_complex_id = record['waterbodycomplexid']
      waterbody.surveyed = record['surveyed_ind'] == 'Y' ? true : false
      waterbody.flows_into_waterbody_id = record['flowsintowaterbodyid']
      waterbody.flows_into_waterbody_name = record['flowsintowaterbodyname']
      waterbody.flows_into_watershed = record['flowintodrainagecd']
      waterbody.date_entered = record['dateentered']
      waterbody.date_modified = record['datemodified']
      waterbody.save!
    rescue Exception => exc
      puts "IMPORT ERROR: #{exc.message} - #{record.inspect}"
    end
  end
end
