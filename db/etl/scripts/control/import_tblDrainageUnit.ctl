###
# ETL control file for importing table tblDrainageUnit
# Generated August 15, 2008 17:15
###

model = Class.new(ActiveRecord::Base) do
  set_table_name 'tbldrainageunit'
end
table = model.table_name.to_s
outfile = "../../output/import_tblDrainageUnit.csv"
columns = model.columns.collect { |column| column.name.to_sym }

source :in, { 
  :type => :access,
  :mdb => "../../input/nb_aquatic_data_warehouse.mdb", 
  :table => table
}, columns

destination :out, { 
  :file => outfile
}, { 
  :order => columns
}  

before_write :nullify

pre_process :truncate, { :target => RAILS_ENV, :table => table }

post_process :bulk_import, { 
  :file => outfile, 
  :columns => columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => table
}
