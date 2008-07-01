src_columns = [:oandmcd, :oandm_type, :oandm_category, :oandm_group, :oandm_parameter, :oandm_valuesind]
dst_columns = [:id, :name, :group, :category, :imported_at, :exported_at, :created_at, :updated_at]
outfile = "output/observables.csv"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "cdOandM"
}, src_columns

rename :oandmcd, :id
rename :oandm_category, :category
rename :oandm_group, :group
rename :oandm_parameter, :name

before_write { |row| row if row[:oandm_type] == 'Observation' }
before_write :check_exist, :target => RAILS_ENV, :table => "observables", :columns => [:id]

destination :out, { 
  :file => outfile
}, { 
  :order => dst_columns,
  :virtual => { 
    :created_at =>  DateTime.now,
    :updated_at =>  DateTime.now,
    :imported_at => DateTime.now
  } 
} 

post_process :bulk_import, { 
  :file => outfile, 
  :columns => dst_columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => "observables"
}