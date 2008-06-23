# ETL Control file
columns = [:agencycd, :id]
codefile = "decode/agency_table.txt"

source :in, { 
  :database => "waterchemistry_dev",
  :target => RAILS_ENV.to_sym, 
  :table => "cdagency"
},  columns

# decode table
destination :out, { 
  :file => codefile,
  :separator => ':'
}, { 
  :order => decode_columns,
} 