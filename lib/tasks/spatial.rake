namespace :spatial do
  desc 'import WGS-84 coordinates for aquatic sites'
  task :import_site_coords => :environment do
    
    require 'geo_ruby'    
    include GeoRuby::Shp4r
    
    ShpFile.open('spatial/aquatic_sites/Aquatic_Sites.shp') do |shp|
      shp.each do |aquatic_site_shape|            
        begin
          attrs = {}
          shp.fields.each { |field| attrs[field.name.downcase] = aquatic_site_shape.data[field.name] }      
          puts "updating aquatic site ##{attrs['aquasiteid']} with coordinate [lat: #{aquatic_site_shape.geometry.lat}, lon: #{aquatic_site_shape.geometry.lon}]"          
          aquatic_site = AquaticSite.find attrs['aquasiteid']  
          if(aquatic_site && aquatic_site_shape.geometry.text_geometry_type == 'POINT')
            aquatic_site.lat = aquatic_site_shape.geometry.lat if aquatic_site.respond_to?(:lat=)  
            aquatic_site.lon = aquatic_site_shape.geometry.lon if aquatic_site.respond_to?(:lon=)     
            aquatic_site.save(false)
          end          
        rescue Exception => e
          puts "ERROR: #{e.message}"
        end
      end  
    end
    
  end
end