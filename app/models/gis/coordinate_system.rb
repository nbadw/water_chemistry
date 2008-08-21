class CoordinateSystem      
  attr_reader :epsg, :name
    
  def initialize(epsg, name)
    @epsg, @name = epsg, name
  end  

  class << self
    def find(epsg_or_name)
      COORDINATE_SYSTEMS.find do |coordinate_system|
        coordinate_system.epsg.to_s == epsg_or_name.to_s || coordinate_system.name == epsg_or_name.to_s
      end
    end  
    
    def all
      COORDINATE_SYSTEMS
    end
  end
  
  COORDINATE_SYSTEMS =  [
    CoordinateSystem.new(4326,  'WGS84'),
    CoordinateSystem.new(4269,  'NAD83'),
    CoordinateSystem.new(2953,  'NAD83 (CSRS) NB Stereographic'),
    CoordinateSystem.new(2200,  'ATS77 NB Stereographic'),
    CoordinateSystem.new(26919, 'NAD83 / UTM zone 19N'),
    CoordinateSystem.new(26920, 'NAD83 / UTM zone 20N'),
    CoordinateSystem.new(26719, 'NAD27 / UTM zone 19N'),
    CoordinateSystem.new(26720, 'NAD27 / UTM zone 20N')
  ]
end
