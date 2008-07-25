src_table   = "cdMeasureInstrument"
src_columns = [:measureinstrumentcd, :oandmcd, :instrumentcd]
dst_table   = "measurement_instrument"
dst_columns = [:id, :measurement_id, :instrument_id]
outfile = "output/#{dst_table}.txt"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => src_table
}, src_columns

rename :measureinstrumentcd, :id
rename :oandmcd, :measurement_id
rename :instrumentcd, :instrument_id

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