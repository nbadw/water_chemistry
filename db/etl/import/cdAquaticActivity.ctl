# ETL Control file
src_columns = [:aquaticactivitycd, :aquaticactivity, :aquaticactivitycategory, :duration]
dst_columns = [:id, :name, :category, :duration, :imported_at, :exported_at, :created_at, :updated_at]
outfile = "output/cd_aquatic_activity.csv"

source :in, { 
  :database => "datawarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "cdAquaticActivity"
},  src_columns

rename :aquaticactivitycd, :id
rename :aquaticactivity, :name
rename :aquaticactivitycategory, :category
before_write :check_exist, :target => RAILS_ENV, :table => "aquatic_activities", :columns => [:id]

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
  :table => "aquatic_activities"
}