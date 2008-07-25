current_coordinate_systems = [
  { :epsg => 4326,  :text => 'WGS84',                        },
  { :epsg => 4269,  :text => 'NAD83',                        },
  { :epsg => 2953,  :text => 'NAD83 (CSRS) NB Stereographic' },
  { :epsg => 2200,  :text => 'ATS77 NB Stereographic'        },
  { :epsg => 26919, :text => 'NAD83 / UTM zone 19N'          },
  { :epsg => 26920, :text => 'NAD83 / UTM zone 20N'          },
  { :epsg => 26719, :text => 'NAD27 / UTM zone 19N'          },
  { :epsg => 26720, :text => 'NAD27 / UTM zone 20N'          }
]

source :in, { 
  :database => "waterchemistry",
  :target => RAILS_ENV, 
  :table => "coordinate_systems"
}, [:id, :epsg, :name]

before_write do |row| 
  text = nil
  current_coordinate_systems.each { |system| text = system[:text] if system[:epsg] == row[:epsg].to_i }
  row[:text] = text
  text ? row : nil
end


destination :out, { 
  :file => "decode/coordinate_system_text_to_id.txt",
  :separator => ':'
}, { 
  :order => [:text, :id]
} 