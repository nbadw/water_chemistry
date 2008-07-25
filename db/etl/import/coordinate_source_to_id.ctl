source :in, { 
  :database => "waterchemistry",
  :target => RAILS_ENV, 
  :table => "coordinate_sources"
}, [:id, :name]

destination :out, { 
  :file => "decode/coordinate_source_to_id.txt",
  :separator => ':'
}, { 
  :order => [:name, :id]
} 