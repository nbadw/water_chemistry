src_columns = [:instrumentcd, :instrument, :instrument_category]
dst_columns = [:id, :name, :category, :imported_at, :exported_at, :created_at, :updated_at]
outfile = "output/instruments.csv"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "cdInstrument"
}, src_columns

rename :instrumentcd, :id
rename :instrument, :name
rename :instrument_category, :category
before_write :check_exist, :target => RAILS_ENV, :table => "instruments", :columns => [:id]

destination :out, { 
  :file => outfile
}, { 
  :order => dst_columns,
  :virtual => { 
    :created_at => Time.now,
    :updated_at => Time.now,
    :imported_at => Time.now
  } 
} 

post_process :bulk_import, { 
  :file => outfile, 
  :columns => dst_columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => "instruments"
}