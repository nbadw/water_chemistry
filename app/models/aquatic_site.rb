class AquaticSite < ActiveRecord::Base
  include AquaticDataWarehouse::IncorporatedModel
  
  class AquaticSiteInUse < ActiveRecord::ActiveRecordError;end  
    
  DEGREES_MINUTES_SECONDS_REGEXP = /^(-?\d{2}\d?)[:d°](\d\d?)[:'](\d\d?[.]?\d*)"?([NSEW]?)$/
  #DECIMAL_DEGREES_REGEXP = //
  DECIMAL_REGEXP = /^(-?\d+[.]?\d*)$/
    
  belongs_to :waterbody 
  has_many   :aquatic_site_usages
  has_many   :aquatic_activities, :through => :aquatic_site_usages, :uniq => true
  has_many   :agencies, :through => :aquatic_site_usages, :uniq => true
  
  #composed_of :actual_location
  #composed_of :balance, :class_name => 'Money', :mapping => [%w(balance amount), %w(currency currency)] do |params|
#    Money.new params[:balance], params[:currency]
#  end
  composed_of :recorded_location, :class_name => 'Location', :mapping => [%w(raw_latitude latitude), %w(raw_longitude longitude), %w(coordinate_system_id coordinate_system_id)]
  composed_of :gmap_location, :class_name => 'Location', :mapping => [%w(gmap_latitude latitude), %w(gmap_longitude longitude), %w(gmap_coordinate_system_id coordinate_system_id)]
        
  before_destroy :destroy_allowed?
    
  validates_presence_of :description, :waterbody  
  
#  validates_each :raw_latitude do |record, attr, val|
#    if any_coordinate_attribute_present?(record)
#      record.errors.add :raw_latitude, "can't be empty" if val.to_s.empty?
#    end    
#  end
#  
#  validates_each :raw_longitude do |record, attr, val|
#    if any_coordinate_attribute_present?(record)
#      record.errors.add :raw_latitude, "can't be empty" if val.to_s.empty?
#    end
#  end  
#  
#  validates_each :coordinate_sourc_d do |record, attr, val|
#    if any_coordinate_attribute_present?(record)
#      record.errors.add :coordinate_source, "can't be empty" if val.to_s.empty?
#    end
#  end
#  
#  validates_each :coordinate_srs_id do |record, attr, val|
#    if any_coordinate_attribute_present?(record)
#      record.errors.add :coordinate_srs_id, "can't be empty" if val.to_s.empty?
#    end
#  end
#  
#  def self.any_coordinate_attribute_present?(record)
#    coordinate_attributes = [:x_coordinate, :y_coordinate, :coordinate_source, :coordinate_srs_id]
#    coordinate_attributes.any? { |attribute| !record.send(attribute).to_s.empty? }
#  end
  
  def drainage_code
    self.waterbody.drainage_code if self.waterbody
  end  
  
  private   
  def destroy_allowed?
    check_if_incorporated
    check_if_in_use
  end
  
  def check_if_in_use
    raise(
      AquaticSiteInUse, 
      "Site is in use, record cannot be deleted"
    ) unless self.aquatic_site_usages.empty?
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
