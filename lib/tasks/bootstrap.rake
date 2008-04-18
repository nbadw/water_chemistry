desc "loads the aquatic sites into the db"
task :bootstrap_sites => :environment do  
  require 'geo_ruby'
  require 'fastercsv'
  include GeoRuby::Shp4r
  
  AquaticSite.delete_all  
  
  aquatic_sites = {}
  rows = FasterCSV.read('spatial/aquatic_sites/aquatic_sites.csv')
  column_names = rows.delete(rows.first)
  rows.each do |row|
    site = AquaticSite.new
    id = 0
    row.each_with_index do |value, i| 
      col_name = column_names[i]
      if col_name == 'id'
        id = value
      else
        site.write_attribute(col_name, value) if col_name
      end
    end    
    aquatic_sites[id.to_i] = site
  end
  
  shpcol2sitecol = {
    'aquasiteid' => 'id',
    'water_id'   => 'waterbody_id',
    'draingecd'  => 'drainage_code'
  }
  ShpFile.open('spatial/aquatic_sites/Aquatic_Sites.shp') do |shp|
    shp.each do |shape|        
      shp_attrs = {}
      shp.fields.each do |field|
        name = shpcol2sitecol[field.name.downcase]
        shp_attrs[name] = shape.data[field.name] if name
      end
      
      site = aquatic_sites[shp_attrs.delete('id')]
      if site
        site.attributes = site.attributes.merge(shp_attrs)        
        site.geom = shape.geometry  
        site.geom.srid = 4326
        site.save
      end
    end
  end
  
end