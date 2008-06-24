# ETL Control file
outfile = "output/agencies.csv"
src_columns = [:agencycd, :agency, :agencytype, :datarulesind]
dst_columns = [:id, :code, :name, :type, :data_rules, :imported_at, :exported_at, :created_at, :updated_at]

source :in, { 
  :database => "datawarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "cdAgency"
}, src_columns

rename :agencycd, :code
rename :agency, :name
rename :agencytype, :type
rename :datarulesind, :data_rules
before_write { |row| row[:code] != "`" ? row : nil }
before_write :check_exist, :target => RAILS_ENV, :table => "agencies", :columns => [:code]

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
  :table => "agencies"
}