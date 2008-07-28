class Location  
  DEGREES_MINUTES_SECONDS_REGEXP = /^(-?\d{2}\d?)[:d°](\d\d?)[:'](\d\d?[.]?\d*)"?([NSEW]?)$/
  #DECIMAL_DEGREES_REGEXP = //
  DECIMAL_REGEXP = /^(-?\d+[.]?\d*)$/
  
  attr_reader :latitude, :longitude, :coordinate_system_id, :errors
  
  def initialize(latitude, longitude, coordinate_system_id)
    @latitude, @longitude, @coordinate_system_id = latitude, longitude, coordinate_system_id  
    @coordinate_system = nil
    @errors = ActiveRecord::Errors.new(self)
  end
  
  def coordinate_system
    @coordinate_system ||= CoordinateSystem.find(coordinate_system_id)
  end
  
  def valid?
    validate
    errors.empty?
  end
  
  def blank?
    latitude.nil? && longitude.nil? && coordinate_system_id.nil?
  end
  
  private
  def validate
    errors.clear
    validate_coordinate_system_id
    validate_latitude
    validate_longitude
  end 
  
  def validate_latitude  
    if latitude
      validate_coordinate_format(:latitude)
    else      
      errors.add :latitude, "latitude cannot be blank"
    end
  end
  
  def validate_longitude
    if latitude
      validate_coordinate_format(:longitude)
    else      
      errors.add :longitude, "longitude cannot be blank"
    end
  end
  
  def validate_coordinate_system_id
    errors.add :coordinate_system_id, "coordinate system with id=#{coordinate_system_id} cannot be found" unless CoordinateSystem.exists?(coordinate_system_id)
  end
  
  def validate_coordinate_format(coordinate)
    val = self.send(coordinate)
  end  
  
  def coordinate_is_decimal_degrees?
    
  end
  
  def coordinate_is_degrees_minutes_seconds?
    
  end
  
  def coordinate_is_decimal?
    
  end
  
#   #region Coordinate Parsing
#
#        private double Parse(string input)
#        {
#            if (IsNumber(input))
#            {
#                return ParseNumber(input);
#            }
#            else if (IsDegreesDecimalMinutes(input))
#            {
#                return ParseDegreesDecimalMinutes(input);
#            }
#            else if (IsDegreesMinutesSeconds(input))
#            {
#                return ParseDegreesMinutesSeconds(input);
#            }
#            else
#            {
#                throw new Exception(String.Format(
#                    "Input value {0} is not in a known format", input
#                ));
#            }
#        }
#
#        private bool IsDegreesMinutesSeconds(string input)
#        {
#            // possible formats
#            // # 40:26:46.302N, 79:56:55.903W
#            // # 40°26'21"N, 79°58'36"W
#            // # 40d26'21"N, 79d58'36"W
#            return Regex.IsMatch(input, DEGREES_MINUTES_SECONDS_REGEXP);
#        }
#
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
#
#        private double ParseDegreesDecimalMinutes(string input)
#        {
#            throw new NotImplementedException();
#        }
#
#        private bool IsNumber(string input)
#        {
#            return Regex.IsMatch(input, NUMBER_REGEXP);
#        }
#
#        private double ParseNumber(string input)
#        {
#            return double.Parse(input);
#        }
end
