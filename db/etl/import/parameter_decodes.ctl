# ETL Control file
table = 'parameters'
columns = [:code, :id]
outfile = "decode/parameter_table.txt"

source :in, {
    :database => "dataWarehouse",
    :target => RAILS_ENV.to_sym,
    :table => "parameters"
}, columns

transform(:code) { |n, v, r| v.downcase }

destination :out, { 
  :file => outfile,
  :separator => ':'
}, { 
  :order => columns
} 