class CoordinateSource
  attr_reader :name
    
  def initialize(name)
    @name = name
  end  
  
  class << self
    def find(name)
      COORDINATE_SOURCES.find do |coordinate_source|
        coordinate_source.name == name.to_s
      end
    end
    
    def all
      COORDINATE_SOURCES
    end
  end

  COORDINATE_SOURCES = [
    CoordinateSource.new("1:50,000 NTS Topographic Map"),
    CoordinateSource.new("GIS"),
    CoordinateSource.new("GPS")
  ]
end
