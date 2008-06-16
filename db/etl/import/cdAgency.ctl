# ETL Control file
columns = [:agencycd, :agency, :agencytype, :datarulesind]
outfile = 'output/agency_table.txt'

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "cdagency"
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
  :target => :operational, 
  :table => "cdagency" 
}