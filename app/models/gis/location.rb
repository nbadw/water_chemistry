require 'cgi'
require 'uri'
require 'net/http'
require 'timeout'

class Location  
  DEGREES_MINUTES_SECONDS_FORMAT = /^(-?\d{2}\d?)[\s:d°](\d\d?)[\s:'](\d\d?[.]?\d*)"?([NSEW]?)$/
  #DECIMAL_DEGREES_REGEXP = //
  DECIMAL_FORMAT = /^(-?\d+[.]?\d*)$/
  
  attr_reader :latitude, :longitude, :coordinate_system_name, :errors
    
  def initialize(latitude, longitude, coordinate_system_name)
    @latitude, @longitude, @coordinate_system_name = latitude, longitude, coordinate_system_name  
    @coordinate_system = nil
    @errors = ActiveRecord::Errors.new(self)
  end
  
  def coordinate_system
    finder = coordinate_system_name.to_s.match(/^\d+$/) ? 'epsg' : 'display_name'
    @coordinate_system ||= CoordinateSystem.send("find_by_#{finder}", coordinate_system_name)
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
    value.to_s.match(DECIMAL_FORMAT) && !has_leading_zeros?(value)
  end

  # check to catch cases where the number is in decimal format
  # but has unnecessary leading zeros - e.g., 01.234, -01.234, 0-123.45
  def has_leading_zeros?(value)
    if value.to_s.match(/\./)  # float value
      value.to_s.to_f.to_s.length != value.to_s.length
    else                       # integer value
      value.to_s.to_i.to_s.length != value.to_s.length
    end
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
    begin
      Coordinate.parse(value)
    rescue
      errors.add attr, :coordinate_in_bad_format_validation_msg.l("is in a bad format")
    end
  end  
end