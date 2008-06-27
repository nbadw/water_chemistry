# ETL Control file
src_columns = [:aquaticsiteid, :oldaquaticsiteid, :riversystemid, :waterbodyid, :waterbodyname, :aquaticsitename,
    :aquaticsitedesc, :habitatdesc, :reachno, :startdesc, :enddesc, :startroutemeas, :endroutemeas, :sitetype,
    :specificsiteind, :georeferencedind, :dateentered, :incorporatedind, :coordinatesource, :coordinatesystem,
    :xcoordinate, :ycoordinate, :coordinateunits, :comments]
dst_columns = [:id, :name, :description, :comments, :waterbody_id, :x_coordinate, :y_coordinate, :coordinate_srs_id, 
    :coordinate_source, :gmap_srs_id, :gmap_latitude, :gmap_longitude, :imported_at, :exported_at, :created_at, :updated_at]
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
rename :xcoordinate, :x_coordinate
rename :ycoordinate, :y_coordinate
rename :coordinatesource, :coordinate_source
rename :coordinatesystem, :coordinate_srs_id

before_write do |row| 
    return nil unless row[:id].to_i > 0

    row[:created_at] = Date.parse(row[:dateentered]) rescue Time.now
    row[:exported_at] = row[:incorporatedind].to_s == 'true' ? Time.now : nil    
    row[:coordinate_srs_id] = 0 
    row[:gmap_srs_id] = 4326 # WGS84

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