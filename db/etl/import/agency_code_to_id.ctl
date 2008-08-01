# ETL Control file
columns = [:agencycode, :id]

source :in, { 
  :database => "waterchemistry",
  :target => RAILS_ENV, 
  :table => "cdagency"
}, columns

destination :out, { 
  :file => "decode/agency_code_to_id.txt",
  :separator => ':'
}, { 
  :order => columns
} 