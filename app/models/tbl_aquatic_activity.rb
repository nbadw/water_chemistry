class TblAquaticActivity < ActiveRecord::Base 
  set_table_name  'tblAquaticActivity'
  set_primary_key 'aquaticactivityid'
  
  alias_attribute :weather_conditions, :weatherconditions
  alias_attribute :rain_fall_in_last_24_hours, :rainfall_last24
  alias_attribute :water_level, :waterlevel
  
  # TODO: should these be process before save or made into actual attributes
  attr_accessor :water_clarity, :water_color, :water_crossing, :point_source, :non_point_source, :watercourse_alteration
  
  def self.rainfall_last24_options
    ["None", "Light", "Heavy"]
  end
  
  def self.weather_conditions_options
    ["Sunny", "Partly Cloudy", "Cloudy", "Raining"]
  end
  
  def self.water_level_options
    ["Low", "Medium", "High"]
  end
  
  belongs_to :aquatic_activity_code, :class_name => 'CdAquaticActivity', :foreign_key => 'aquaticactivitycd' 
  belongs_to :aquatic_site, :class_name => 'TblAquaticSite', :foreign_key => 'aquaticsiteid'
  belongs_to :agency, :class_name => 'CdAgency', :foreign_key => 'agencycd'
  belongs_to :agency2, :class_name => 'CdAgency', :foreign_key => 'agency2cd'
  belongs_to :aquatic_activity_method_code, :class_name => 'CdAquaticActivityMethod', :foreign_key => 'aquaticmethodcd'
    
  validates_inclusion_of :rainfall_last24, :in => self.rainfall_last24_options
  validates_inclusion_of :weather_conditions, :in => self.weather_conditions_options
  validates_inclusion_of :water_level, :in => self.water_level_options
  
  acts_as_importable
  
  def start_date
    date_str = "#{self.aquaticactivitystartdate} #{self.aquaticactivitystarttime}".strip
    date_str = "#{date_str}/01/01" if date_str.match(/^\d{4}\/?$/) # some times we only get the year back
    start_date = nil
    begin
      start_date = DateTime.parse date_str unless date_str.empty?
    rescue
      logger.error "couldn't parse start date #{date_str} for #{self.inspect}" if logger.error?
    end
    start_date
  end
  
  def end_date
    date_str = "#{self.aquaticactivityenddate} #{self.aquaticactivityendtime}".strip
    date_str = "#{date_str}/01/01" if date_str.match(/^\d{4}\/?$/) # some times we only get the year back
    end_date = nil
    begin
      end_date = DateTime.parse date_str unless date_str.empty?
    rescue
      logger.error "couldn't parse end date #{date_str} for #{self.inspect}" if logger.error?
    end
    end_date
  end  
end
