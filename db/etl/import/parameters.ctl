# ETL Control file
table = 'parameters'
source_columns = [:name, :code]
destination_columns = [:id, :name, :code, :created_at, :updated_at]
outfile = "output/parameters.csv"

source :in, {  
  :file => "input/DENV_parameter_list.csv",  
  :parser => :delimited  
}, source_columns

destination :out, { 
  :file => outfile
}, { 
  :order => destination_columns, 
  :virtual => { 
    :id => :surrogate_key,
    :created_at => Time.now,
    :updated_at => Time.now
  }
} 

post_process :bulk_import, { 
  :file => outfile, 
  :columns => destination_columns, 
  :field_separator => ",", 
  :target => RAILS_ENV.to_sym, 
  :table => table
}