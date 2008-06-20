# ETL Control file
model = TblAquaticSite
table = model.table_name.to_s.downcase
columns = model.columns.collect { |col| col.name.to_sym }
outfile = "output/#{model.to_s.underscore}.txt"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => table
},  columns

destination :out, { 
  :file => outfile
}, { 
  :order => columns 
} 

before_write do |row| 
    row[:incorporatedind] = row[:incorporatedind].strip == 'true' ? 1 : 0
    row
end

before_write do |row|
    row[:aquaticsiteid].to_i > 0 ? row : nil
end

before_write :nullify, :fields => columns

post_process :bulk_import, { 
  :file => outfile, 
  :columns => columns, 
  :field_separator => ",", 
  :target => RAILS_ENV.to_sym, 
  :table => table
}

post_process :coordinate_import, {
  :shape_file => 'input/Aquatic_Sites.shp',
  :shape_id => :aquasiteid,  
  :target => RAILS_ENV.to_sym, 
  :table => table,
  :id_column => :aquaticsiteid,
  :lat_column => :wgs84_lat,
  :lng_column => :wgs84_lon
}