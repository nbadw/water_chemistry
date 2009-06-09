require 'cgi'
require 'uri'
require 'net/http'
require 'timeout'

class Location  
  DEGREES_MINUTES_SECONDS_FORMAT = /^(-?\d{2}\d?)[:d°](\d\d?)[:'](\d\d?[.]?\d*)"?([NSEW]?)$/
  #DECIMAL_DEGREES_REGEXP = //
  DECIMAL_FORMAT = /^(-?\d+[.]?\d*)$/
  
  attr_reader :latitude, :longitude, :coordinate_system_name, :errors
    
  def initialize(latitude, longitude, coordinate_system_name)
    @latitude, @longitude, @coordinate_system_name = latitude, longitude, coordinate_system_name  
    @coordinate_system = nil
    @errors = ActiveRecord::Errors.new(self)
  end
  
  def convert_to_gmap_location    
    service = "http://cri.nbwaters.unb.ca/services/project/coordinate.castle"
    wgs84 = 4326 # epsg for WGS84 coordinate system
    query_params = "x=#{CGI.escapeHTML(longitude.to_s)}&y=#{CGI.escapeHTML(latitude.to_s)}&from=#{coordinate_system.id}&to=#{wgs84}"    
    
    begin
      response = nil
      successful = Timeout::timeout(15) do
        response = Net::HTTP.get(URI.parse("#{service}?#{query_params}" ))
      end   

      unless successful || !response.kind_of?(HTTPSuccess)
        error_msg = :coordinate_conversion_service_unavailable.l('Sorry, the coordinate conversion service is not working.  Try again later.')
        raise error_msg
      end
                  
      json = response
      if json.match(/\{"x":(.*),"y":(.*)\}/)
        x, y = $1, $2
        GmapLocation.new(:longitude => x, :latitude => y)
      end
    rescue
      raise
    end
  end
  
  def coordinate_system
    @coordinate_system ||= CoordinateSystem.find_by_display_name(coordinate_system_name)
  end
  
  def valid?
    validate
    errors.empty?
  end
  
  def blank?
    latitude.to_s.blank? && longitude.to_s.blank? && coordinate_system_name.to_s.blank?
  end  
  
  def decimal_degrees_latitude?
    decimal_degrees_format?(latitude)
  end
  
  def degrees_minutes_seconds_latitude?
    degrees_minutes_seconds_format?(latitude)
  end
  
  def decimal_latitude?
    decimal_format?(latitude)
  end
  
  def decimal_degrees_longitude?
    decimal_degrees_format?(longitude)
  end
  
  def degrees_minutes_seconds_longitude?
    degrees_minutes_seconds_format?(longitude)
  end
  
  def decimal_longitude?
    decimal_format?(longitude)
  end
  
  private
  def decimal_format?(value)
    !value.to_s.match(DECIMAL_FORMAT).nil?
  end
  
  def decimal_degrees_format?(value)
    false
  end
  
  def degrees_minutes_seconds_format?(value)
    !value.to_s.match(DEGREES_MINUTES_SECONDS_FORMAT).nil?
  end
  
  def validate
    errors.clear
    validate_coordinate_system
    validate_latitude
    validate_longitude
  end 
  
  def validate_latitude  
    unless latitude.to_s.blank?
      validate_coordinate_format(:latitude)
    else      
      errors.add_on_blank :latitude
    end
  end
  
  def validate_longitude
    unless longitude.to_s.blank?
      validate_coordinate_format(:longitude)
    else      
      errors.add_on_blank :longitude
    end
  end
  
  def validate_coordinate_system
    unless coordinate_system_name.to_s.blank?
      errors.add :coordinate_system, :coordinate_system_not_found_validation_msg.l('not found') if coordinate_system.nil?
    else
      errors.add_on_blank :coordinate_system
    end
  end
  
  def validate_coordinate_format(attr)
    value = self.send(attr)
    unless decimal_format?(value) || decimal_degrees_format?(value) || degrees_minutes_seconds_format?(value)
      errors.add attr, :coordinate_in_bad_format_validation_msg.l("is in a bad format")
    end
  end  
end