# ETL Control file
model = TblWaterMeasurement
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

post_process :bulk_import, { 
  :file => outfile, 
  :columns => columns, 
  :field_separator => ",", 
  :target => RAILS_ENV.to_sym, 
  :table => table
}