src_columns = [:oandmvaluescd, :oandmcd, :value]
dst_columns = [:id, :observable_id, :value, :created_at, :updated_at, :imported_at, :exported_at]
outfile = "output/observable_values.txt"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "cdOAndMValues"
}, src_columns

rename :oandmvaluescd, :id
rename :oandmcd, :observable_id
before_write :check_exist, :target => RAILS_ENV, :table => "observable_values", :columns => [:id]

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
  :columns => columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => "observable_values"
}