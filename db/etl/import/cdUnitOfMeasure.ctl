# ETL Control file
src_columns = [:unitofmeasurecd, :unitofmeasure, :unitofmeasureabv]
dst_columns = [:id, :name, :unit, :imported_at, :exported_at, :created_at, :updated_at]
outfile = "output/measurement_units.csv"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "cdUnitOfMeasure"
}, src_columns

rename :unitofmeasurecd, :id
rename :unitofmeasure, :name
rename :unitofmeasureabv, :unit
before_write :check_exist, :target => RAILS_ENV, :table => "measurement_units", :columns => [:id]

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
  :table => "measurement_units"
}