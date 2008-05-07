class CreateAquaticSites < ActiveRecord::Migration
  class DwAquaticSite < ActiveRecord::Base
    set_table_name  'tblaquaticsite'
    set_primary_key 'aquaticsiteid'
  end
  
  class AquaticSite < ActiveRecord::Base    
  end
  
  def self.up
    create_table :aquatic_sites do |t|
      t.integer   :dw_aquatic_site_id
      t.integer   :old_aquatic_site_id
      t.integer   :river_system_id
      t.integer   :waterbody_id
      t.string    :name
      t.string    :description
      t.string    :habitat_desc
      t.integer   :reach_no
      t.string    :start_desc
      t.string    :end_desc
      t.float     :start_route_meas
      t.float     :end_route_meas
      t.string    :site_type
      t.boolean   :specific_site
      t.boolean   :georeferenced
      t.timestamp :entered_at
      t.timestamp :incorporated_at
      t.string    :coordinate_source
      t.string    :coordinate_system
      t.string    :coordinate_units
      t.string    :x_coord
      t.string    :y_coord
      t.string    :comments
      t.timestamps
    end 

    records = read_aquatic_sites_from_data_warehouse    
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
    records.each_with_index do |record, i|      
      puts "importing record #{i+1} of #{records.size}"
      import(record)
    end    
  end

  def self.down
    drop_table :aquatic_sites
  end
  
  def self.read_aquatic_sites_from_data_warehouse
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
    puts 'reading data from tblAquaticSite'
    records = DwAquaticSite.find :all
    puts "#{records.size} records ready for import"   
    records.collect { |record| record.attributes }
  end
  
  def self.import(record)
    begin
      raise 'aquatic site ID for datawarehouse is missing' unless record.has_key? 'aquaticsiteid'      
      site = AquaticSite.new
      site.dw_aquatic_site_id = record['aquaticsiteid']
      site.old_aquatic_site_id = record['oldaquaticsiteid']
      site.river_system_id = record['riversystemid']
      site.waterbody_id = record['waterbodyid']
      site.name = record['aquaticsitename']
      site.description = record['aquaticsitedesc']
      site.habitat_desc = record['habitatdesc']
      site.reach_no = record['reachno']
      site.start_desc = record['startdesc']
      site.end_desc = record['enddesc']
      site.start_route_meas = record['startroutemeas']
      site.end_route_meas = record['endroutemeas']
      site.site_type = record['sitetype']
      site.specific_site = record['specificsiteind'] == 'Y' ? true : false
      site.georeferenced = record['georeferenced'] == 'Y' ? true : false
      site.entered_at = record['date_entered']
      site.incorporated_at = record['incorporatedind'] ? DateTime.now : nil
      site.coordinate_source = record['coordinatesource']
      site.coordinate_system = record['coordinatesystem']
      site.coordinate_units = record['coordinateunits']
      site.x_coord = record['xcoordinate']
      site.y_coord = record['ycoordinate']
      site.comments = record['comments']
      site.save!
    rescue Exception => exc
      puts "IMPORT ERROR: #{exc.message} - #{record.inspect}"
    end
  end
end
