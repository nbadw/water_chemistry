require File.dirname(__FILE__) + '/location'
class GmapLocation < Location
  def initialize(latitude, longitude)
    coordinate_system_id = 4326 unless latitude.to_s.empty? && longitude.to_s.empty?
    super(latitude, longitude, coordinate_system_id)
  end
end
