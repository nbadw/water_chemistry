# ETL Control file
src_columns = [:aquaticmethodcd, :aquaticactivitycd, :aquaticmethod]
dst_columns = [:id, :aquatic_activity_id, :method, :imported_at, :exported_at, :created_at, :updated_at]
outfile = "output/cd_aquatic_activity_method.csv"

source :in, { 
  :database => "datawarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "cdAquaticActivityMethod"
},  src_columns

rename :aquaticmethodcd, :id
rename :aquaticactivitycd, :aquatic_activity_id
rename :aquaticmethod, :method
before_write :check_exist, :target => RAILS_ENV, :table => "aquatic_activity_methods", :columns => [:id]

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
  :table => "aquatic_activity_methods"
}