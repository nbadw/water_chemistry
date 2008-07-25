# ETL Control file
src_columns = [:aquaticsiteid, :oldaquaticsiteid, :riversystemid, :waterbodyid, :waterbodyname, :aquaticsitename,
  :aquaticsitedesc, :habitatdesc, :reachno, :startdesc, :enddesc, :startroutemeas, :endroutemeas, :sitetype,
  :specificsiteind, :georeferencedind, :dateentered, :incorporatedind, :coordinatesource, :coordinatesystem,
  :xcoordinate, :ycoordinate, :coordinateunits, :comments]
dst_columns = [:id, :name, :description, :comments, :waterbody_id, :coordinate_system_id,  :coordinate_source_id,
  :raw_latitude, :raw_longitude, :latitude, :longitude, :gmap_coordinate_system_id, :gmap_latitude, :gmap_longitude, 
  :imported_at, :exported_at, :created_at, :updated_at]
outfile = "output/aquatic_sites.csv"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "tblAquaticSite"
}, src_columns

rename :aquaticsiteid, :id
rename :aquaticsitename, :name
rename :aquaticsitedesc, :description
rename :waterbodyid, :waterbody_id
rename :xcoordinate, :raw_latitude
rename :ycoordinate, :raw_longitude
rename :coordinatesource, :coordinate_source_id
rename :coordinatesystem, :coordinate_system_id

transform :gmap_coordinate_system_id, :default, :default_value => "WGS84"
transform :coordinate_source_id, :decode, :decode_table_path => 'decode/coordinate_source_to_id.txt', :default_value => ''
transform :coordinate_system_id, :decode, :decode_table_path => 'decode/coordinate_system_text_to_id.txt', :default_value => ''
transform :gmap_coordinate_system_id, :decode, :decode_table_path => 'decode/coordinate_system_text_to_id.txt', :default_value => ''

before_write do |row| 
  return nil if row[:id].to_i <= 0  
  row[:created_at] = DateTime.parse(row[:dateentered]) rescue DateTime.now
  row[:exported_at] = row[:incorporatedind].to_s == 'true' ? DateTime.now : nil 
  puts "id=#{row[:id]}, created_at=#{row[:created_at]}, exported_at=#{row[:exported_at]}"   
  row
end
before_write :check_exist, :target => RAILS_ENV, :table => "aquatic_sites", :columns => [:id]

destination :out, { 
  :file => outfile
}, { 
  :order => dst_columns,
  :virtual => { 
    :updated_at => Time.now,
    :imported_at => Time.now
  } 
} 

post_process :bulk_import, { 
  :file => outfile, 
  :columns => dst_columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => "aquatic_sites"
}

post_process :coordinate_import, {
  :shape_file => 'input/aquatic_sites.shp',
  :shape_id => :aquasiteid,  
  :target => RAILS_ENV, 
  :table => :aquatic_sites,
  :lat_column => :gmap_latitude,
  :lng_column => :gmap_longitude
}