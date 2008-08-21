class Location  
  DEGREES_MINUTES_SECONDS_FORMAT = /^(-?\d{2}\d?)[:d°](\d\d?)[:'](\d\d?[.]?\d*)"?([NSEW]?)$/
  #DECIMAL_DEGREES_REGEXP = //
  DECIMAL_FORMAT = /^(-?\d+[.]?\d*)$/
  
  attr_reader :latitude, :longitude, :coordinate_system_id, :errors
    
  def initialize(latitude, longitude, coordinate_system_id)
    @latitude, @longitude, @coordinate_system_id = latitude, longitude, coordinate_system_id  
    @coordinate_system = nil
    @errors = ActiveRecord::Errors.new(self)
  end
  
  def copy_errors_to(record, mapping)    
    [self.errors.on(:latitude)].flatten.each  { |error| record.errors.add mapping[0], error }
    [self.errors.on(:longitude)].flatten.each { |error| record.errors.add mapping[1], error }
    if mapping[2]
      [self.errors.on(:coordinate_system_id)].flatten.each { |error| record.errors.add mapping[2], error }
    end
  end
  
  def coordinate_system
    @coordinate_system ||= CoordinateSystem.find(coordinate_system_id)
  end
  
  def valid?
    validate
    errors.empty?
  end
  
  def blank?
    latitude.to_s.blank? && longitude.to_s.blank? && coordinate_system_id.to_s.blank?
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
    validate_coordinate_system_id
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
  
  def validate_coordinate_system_id
    unless coordinate_system_id.to_s.blank?
      errors.add :coordinate_system_id, "not found" if coordinate_system.nil?
    else
      errors.add_on_blank :coordinate_system_id
    end
  end
  
  def validate_coordinate_format(attr)
    value = self.send(attr)
    unless decimal_format?(value) || decimal_degrees_format?(value) || degrees_minutes_seconds_format?(value)
      errors.add attr, "is in a bad format"
    end
  end  
  
#        private double ParseDegreesMinutesSeconds(string input)
#        {
#            Match match = Regex.Match(input, DEGREES_MINUTES_SECONDS_REGEXP);
#            int degrees      = int.Parse(match.Groups[1].Value);
#            int minutes      = int.Parse(match.Groups[2].Value);
#            double seconds   = double.Parse(match.Groups[3].Value);
#            string direction = match.Groups[4].Value;
#
#            if (degrees < 0 && !String.IsNullOrEmpty(direction))
#            {
#                throw new Exception("Value can't have both a negative degree value and a NSEW specifier");
#            }
#
#            double decimalDegrees = Math.Abs(degrees) + (minutes * 60 + seconds) / 3600;
#            if (degrees < 0)
#            {
#                decimalDegrees = decimalDegrees * -1;
#            }
#            else if (!String.IsNullOrEmpty(direction))
#            {
#                if ("S".Equals(direction) || "W".Equals(direction))
#                {
#                    decimalDegrees = decimalDegrees * -1;
#                }
#            }
#            return decimalDegrees;
#        }
#
#        private bool IsDegreesDecimalMinutes(string input)
#        {
#            // possible formats
#            // # 40.446195N 79.948862W
#            // # 40.446195, -79.948862
#            // # 40° 26.7717, -79° 56.93172
#            return false;
#        }
end
