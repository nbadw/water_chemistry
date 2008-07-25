src_columns = [:oandmvaluescd, :oandmcd, :value]
dst_columns = [:id, :observation_id, :value, :created_at, :updated_at, :imported_at, :exported_at]
outfile = "output/observable_values.txt"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "cdOAndMValues"
}, src_columns

rename :oandmvaluescd, :id
rename :oandmcd, :observation_id

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
  :table => "observable_values"
}