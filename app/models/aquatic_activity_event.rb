class AquaticActivityEvent < ActiveRecord::Base   
  # TODO: should these be processed before save or made into actual attributes?
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
  
  belongs_to :aquatic_activity
  belongs_to :aquatic_site
  belongs_to :agency
  belongs_to :agency2, :class_name => 'Agency'
  belongs_to :aquatic_activity_method
      
  validates_inclusion_of :rainfall_last24, :in => self.rainfall_last24_options, :allow_nil => true, :allow_blank => true
  validates_inclusion_of :weather_conditions, :in => self.weather_conditions_options, :allow_nil => true, :allow_blank => true
  validates_inclusion_of :water_level, :in => self.water_level_options, :allow_nil => true, :allow_blank => true
  validates_presence_of  :aquatic_site, :aquatic_activity, :agency, :aquatic_activity_method, :start_date     
end
