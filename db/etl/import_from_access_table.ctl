puts "importing #{table} from #{mdb_file}"

model = Class.new(ActiveRecord::Base) { set_table_name table.downcase }
columns = model.columns.collect { |col| col.name.to_sym }
outfile = "output/#{table}.txt"
table = model.table_name.downcase

source :in, { 
  :type => :access,
  :mdb => mdb_file, 
  :table => table
}, columns

destination :out, { 
  :file => outfile
}, { 
  :order => columns 
} 

post_process :bulk_import, { 
  :file => outfile, 
  :columns => columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => table
}