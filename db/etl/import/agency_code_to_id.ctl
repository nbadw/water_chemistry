# ETL Control file
columns = [:code, :id]

source :in, { 
  :database => "waterchemistry",
  :target => RAILS_ENV, 
  :table => "agencies"
},  columns

destination :out, { 
  :file => "decode/agency_code_to_id.txt",
  :separator => ':'
}, { 
  :order => columns,
} 