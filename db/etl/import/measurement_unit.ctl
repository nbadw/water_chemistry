src_columns = []
dst_columns = []
outfile = "output/measurement_unit.txt"

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
  :target => RAILS_ENV, 
  :table => table
}