# ETL Control file
model = CdAgency
table = model.table_name.to_s.downcase
columns = model.columns.collect { |col| col.name.to_sym }
outfile = "output/#{model.to_s.underscore}.txt"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => table
},  columns

before_write do |row|
    row[:agencycd] != "`" ? row : nil
end

destination :out, { 
  :file => outfile
}, { 
  :order => [:id] + columns,
  :virtual => { :id => :surrogate_key }
}  

post_process :bulk_import, { 
  :file => outfile, 
  :columns => columns, 
  :field_separator => ",", 
  :target => RAILS_ENV.to_sym, 
  :table => table
}