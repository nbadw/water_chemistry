#require 'UniversalDetector'
#require 'iconv'

class CreateWatersheds < ActiveRecord::Migration  
  class DrainageUnit < ActiveRecord::Base
    set_table_name  'tblDrainageUnit'
    set_primary_key 'drainagecd'
  end
  
  class Watershed < ActiveRecord::Base    
  end
  
  def self.up
    create_table :watersheds do |t|
      t.string  "drainage_code", :null => false, :unique => true
      t.string  "name"
      t.string  "unit_type"
      t.boolean "border"
      t.integer "stream_order"
      t.float   "area_ha"
      t.float   "area_percent"
      t.string  "drains_into"
      6.times do |i|        
        t.string "level#{i+1}_no"
        t.string "level#{i+1}_name"
      end
      t.timestamps
    end
    
    records = read_drainage_units_from_data_warehouse  
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
    records.each_with_index do |record, i|    
#      encode(record)
      puts "importing record #{i+1} of #{records.size}"
      import(record)
    end
  end

  def self.down
    drop_table :watersheds
  end
  
  def self.read_drainage_units_from_data_warehouse
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
    puts 'reading data from tblDrainageUnit'
    records = DrainageUnit.find :all
    puts "#{records.size} records ready for import"   
    records.collect { |record| record.attributes }
  end
  
#  def self.encode(record)
#    record.each do |key, value|      
#      if(value.is_a?(String))
#        guess = UniversalDetector::chardet(value)
#        record[key] = Iconv.new(guess['encoding'], 'utf-8').iconv(value)
#      end
#    end
#    record
#  end
  
  def self.import(record)
    begin      
      watershed = Watershed.new
      watershed.drainage_code = record['drainagecd']
      watershed.name = record['unitname']
      watershed.unit_type = record['unittype']
      watershed.border = record['borderind'] || false
      watershed.stream_order = record['streamorder']
      watershed.area_ha = record['area_ha']
      watershed.area_percent = record['area_percent']
      watershed.drains_into = record['drainsinto']
      6.times do |i|
        watershed.send("level#{i+1}_no=".to_sym, record["level#{i+1}no"])
        watershed.send("level#{i+1}_name=".to_sym, record["level#{i+1}name"])
      end
      watershed.save!
    rescue Exception => exc
      puts "IMPORT ERROR: #{exc.message} - #{record.inspect}"
    end
  end
  
end
