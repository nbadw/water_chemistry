# ETL Control file
columns = [:code, :id]

source :in, { 
  :database => "waterchemistry",
  :target => RAILS_ENV, 
  :table => "agencies"
},  columns

destination :out, { 
  :file => "decode/cd_agency.txt",
  :separator => ':'
}, { 
  :order => columns,
} 