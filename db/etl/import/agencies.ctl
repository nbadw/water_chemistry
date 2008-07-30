# ETL Control file
model = Agency
table = model.table_name.to_s
outfile = "output/#{table}.csv"
columns = model.columns.collect { |column| column.name.to_sym }

source :in, { 
  :type => :access,
  :mdb => "C:/Documents and Settings/nbdata/Desktop/data entry/WaterChemTables.mdb", 
  :table => table
}, columns

before_write { |row| row[Agency.code_column] != "`" ? row : nil }
before_write :check_exist, :target => RAILS_ENV, :table => table, :columns => [Agency.code_column]

destination :out, { 
  :file => outfile
}, { 
  :order => columns,
  :virtual => { 
    :id => :surrogate_key,
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
  :table => table
}