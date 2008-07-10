src_table   = "cdMeasureUnit"
src_columns = [:measureunitcd, :oandmcd, :unitofmeasurecd]
dst_table   = "measurement_unit"
dst_columns = [:id, :measurement_id, :unit_of_measure_id]
outfile = "output/#{dst_table}.txt"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => src_table
}, src_columns

rename :measureunitcd, :id
rename :oandmcd, :measurement_id
rename :unitofmeasurecd, :unit_of_measure_id
before_write :check_exist, :target => RAILS_ENV, :table => dst_table, :columns => [:id]

destination :out, { 
  :file => outfile
}, { 
  :order => dst_columns 
} 

post_process :bulk_import, { 
  :file => outfile, 
  :columns => dst_columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => dst_table
}