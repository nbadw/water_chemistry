class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|    
      t.integer :dw_aquatic_activity_code
      t.string  :name,     :null => false
      t.text    :desc
      t.string  :category, :null => false
      t.string  :duration
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
    drop_table :activities
  end
  
  class DwActivity < ActiveRecord::Base
    set_table_name  'cdAquaticActivity'
    set_primary_key 'aquaticactivitycd'
  end
  
  class Activity < ActiveRecord::Base    
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
    puts "reading data from #{DwActivity.table_name}"
    records = DwActivity.find :all
    puts "#{records.size} records ready for import"   
    records.collect { |record| record.attributes }
  end
  
  def self.import(attributes)
    begin      
      record = Activity.new
      record.dw_aquatic_activity_code = attributes['aquaticactivitycd']
      record.name = attributes['aquaticactivity']
      record.category = attributes['aquaticactivitycategory']
      record.duration = attributes['duration']
      record.save!
    rescue Exception => exc
      puts "IMPORT ERROR: #{exc.message} - #{attributes.inspect}"
    end
  end
end
