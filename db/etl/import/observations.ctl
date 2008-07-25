src_columns = [:oandmcd, :oandm_type, :oandm_category, :oandm_group, :oandm_parameter, :oandm_parametercd, :oandm_valuesind, :oandm_detailsind, :fishpassageind, :bankind]
dst_columns = [:id, :name, :grouping, :category, :fish_passage_blocked_observation, :imported_at, :exported_at, :created_at, :updated_at]
outfile = "output/observations.csv"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "cdOandM"
}, src_columns


transform(:fishpassageind) { |name, val, row| val == 'true' ? 1 : 0 }

rename :oandmcd, :id
rename :oandm_category, :category
rename :oandm_group, :grouping
rename :oandm_parameter, :name
rename :fishpassageind, :fish_passage_blocked_observation

before_write { |row| row if row[:oandm_type] == 'Observation' }

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
  :table => "observations"
}