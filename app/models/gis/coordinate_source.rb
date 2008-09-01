class CoordinateSource
  attr_reader :id, :name
    
  def initialize(id, name)
    @id, @name = id, name
  end  
  
  class << self
    def find(name_or_id)
      COORDINATE_SOURCES.find do |coordinate_source|
        coordinate_source.id.to_s == name_or_id.to_s || coordinate_source.name == name_or_id.to_s
      end
    end
    
    def all
      COORDINATE_SOURCES
    end
  end

  COORDINATE_SOURCES = [
    CoordinateSource.new(0, "1:50,000 NTS Topographic Map"),
    CoordinateSource.new(1, "GIS"),
    CoordinateSource.new(2, "GPS")
  ]
end
