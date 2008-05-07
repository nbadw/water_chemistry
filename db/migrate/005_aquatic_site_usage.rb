class AquaticSiteUsage < ActiveRecord::Migration
  class DwAquaticSiteUsage < ActiveRecord::Base
    set_table_name  'tblaquaticsiteagencyuse'
    set_primary_key 'aquaticsiteuseid'
  end
  
  class AquaticSiteUsage < ActiveRecord::Base    
  end
  
  def self.up
    create_table :aquatic_site_usages do |t|
      t.integer   :dw_aquatic_site_use_id
      t.integer   :aquatic_site_id
      t.integer   :aquatic_activity_code
      t.string    :aquatic_site_type
      t.string    :agency_code
      t.string    :agency_site_id
      t.string    :start_year
      t.string    :end_year
      t.string    :years_active
      t.timestamp :incorporated_at
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
    drop_table :aquatic_site_usages
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
    puts 'reading data from tblAquaticSiteAgencyUse'
    records = DwAquaticSiteUsage.find :all
    puts "#{records.size} records ready for import"   
    records.collect { |record| record.attributes }
  end
  
  def self.import(attributes)
    begin      
      record = AquaticSiteUsage.new
      record.dw_aquatic_site_use_id = attributes['aquaticsiteuseid']
      record.aquatic_site_id = attributes['aquaticsiteid']
      record.aquatic_activity_code = attributes['aquaticactivitycd']
      record.aquatic_site_type = attributes['aquaticsitetype']
      record.agency_code = attributes['agencycd']
      record.agency_site_id = attributes['agencysiteid']
      record.start_year = attributes['startyear']
      record.end_year = attributes['endyear']
      record.years_active = attributes['yearsactive']
      record.incorporated_at = attributes['incorporatedind'] ? DateTime.now : nil
      record.save!
    rescue Exception => exc
      puts "IMPORT ERROR: #{exc.message} - #{attributes.inspect}"
    end
  end
end
