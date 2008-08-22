# == Schema Information
# Schema version: 1
#
# Table name: tblaquaticactivity
#
#  aquaticactivityid        :integer(11)     not null, primary key
#  tempaquaticactivityid    :integer(11)     
#  project                  :string(100)     
#  permitno                 :string(20)      
#  aquaticprogramid         :integer(11)     
#  aquaticactivitycd        :integer(11)     
#  aquaticmethodcd          :integer(11)     
#  oldaquaticsiteid         :integer(11)     
#  aquaticsiteid            :integer(11)     
#  aquaticactivitystartdate :string(10)      
#  aquaticactivityenddate   :string(10)      
#  aquaticactivitystarttime :string(6)       
#  aquaticactivityendtime   :string(6)       
#  year                     :string(4)       
#  agencycd                 :string(4)       
#  agency2cd                :string(4)       
#  agency2contact           :string(50)      
#  aquaticactivityleader    :string(50)      
#  crew                     :string(50)      
#  weatherconditions        :string(50)      
#  watertemp_c              :float           
#  airtemp_c                :float           
#  waterlevel               :string(6)       
#  waterlevel_cm            :string(50)      
#  waterlevel_am_cm         :string(50)      
#  waterlevel_pm_cm         :string(50)      
#  siltation                :string(50)      
#  primaryactivityind       :boolean(1)      
#  comments                 :string(250)     
#  dateentered              :datetime        
#  incorporatedind          :boolean(1)      
#  datetransferred          :datetime        
#  start_date               :datetime        
#  end_date                 :datetime        
#  rainfall_last24          :string(15)      
#  imported_at              :datetime        
#  exported_at              :datetime        
#  created_at               :datetime        
#  updated_at               :datetime        
#  agency2_id               :integer(11)     
#  agency_id                :integer(11)     
#

class AquaticActivityEvent < ActiveRecord::Base 
  set_table_name  :tblaquaticactivity
  set_primary_key :aquaticactivityid
  
  class << self
    def aquatic_activity_id_column
      :aquaticactivitycd
    end
    
    def aquatic_activity_method_id_column
      :aquaticmethodcd
    end
    
    def aquatic_site_id_column
      :aquaticsiteid
    end
    
    def secondary_agency_id_column
      :agency2_id
    end
    
    def rainfall_last24_options
      ["None", "Light", "Heavy"]
    end

    def weather_conditions_options
      ["Sunny", "Partly Cloudy", "Cloudy", "Raining"]
    end

    def water_level_options
      ["Low", "Medium", "High"]
    end
  end
     
  belongs_to :aquatic_activity, :foreign_key => self.aquatic_activity_id_column
  belongs_to :aquatic_site, :foreign_key => self.aquatic_site_id_column
  belongs_to :agency, :foreign_key => 'agencycd'
  belongs_to :secondary_agency, :class_name => 'Agency', :foreign_key => self.secondary_agency_id_column
  belongs_to :aquatic_activity_method, :foreign_key => self.aquatic_activity_method_id_column
    
  # TODO: should these be processed before save or made into actual attributes?
  attr_accessor :water_clarity, :water_color, :water_crossing, :point_source, :non_point_source, :watercourse_alteration
  
  alias_attribute :rain_fall_in_last_24_hours, :rainfall_last24
  
  alias_attribute :temporary_aquatic_activity_id, :tempaquaticactivityid
  
  alias_attribute :permit_no, :permitno
  
  alias_attribute :aquatic_program_id, :aquaticprogramid
  
  alias_attribute :aquatic_activity_cd, :aquaticactivitycd  
  alias_attribute :aquatic_activity_id, :aquaticactivitycd
  
  alias_attribute :aquatic_activity_method_id, :aquaticmethodcd
  
  alias_attribute :aquatic_site_id, :aquaticsiteid
  
  alias_attribute :old_aquatic_site_id, :oldaquaticsiteid
  
  alias_attribute :aquatic_activity_start_date, :aquaticactivitystartdate
  
  alias_attribute :aquatic_activity_end_date, :aquaticactivityenddate
  
  alias_attribute :aquatic_activity_start_time, :aquaticactivitystarttime
  
  alias_attribute :aquatic_activity_end_time, :aquaticactivityendtime
  
  alias_attribute :agency_cd, :agencycd
  alias_attribute :agency_code, :agencycd
  
  alias_attribute :agency2_cd, :agency2cd
  alias_attribute :secondary_agency_code, :agency2cd
  
  alias_attribute :secondary_agency_id, :agency2_id
  
  alias_attribute :agency2_contact, :agency2contact
  alias_attribute :secondary_agency_contact, :agency2contact
  
  alias_attribute :aquatic_activity_leader, :aquaticactivityleader
  alias_attribute :activity_leader, :aquaticactivityleader
  
  alias_attribute :weather_conditions, :weatherconditions
  
  alias_attribute :water_temperature_c, :watertemp_c
  
  alias_attribute :air_temperature_c, :airtemp_c
  
  alias_attribute :water_level, :waterlevel
  
  alias_attribute :water_level_cm, :waterlevel_cm
  
  alias_attribute :water_level_am_cm, :waterlevel_am_cm  
  alias_attribute :morning_water_level_cm, :waterlevel_am_cm
  
  alias_attribute :water_level_pm_cm, :waterlevel_pm_cm
  alias_attribute :evening_water_level_cm, :waterlevel_pm_cm
  
  alias_attribute :primary_activity_ind, :primaryactivityind
  alias_attribute :primary_activity_indicator, :primaryactivityind
  alias_attribute :primary_activity, :primaryactivityind
  
  alias_attribute :date_entered, :dateentered
  
  alias_attribute :incorporated_ind, :incorporatedind
  alias_attribute :incorporated_indicator, :incorporatedind
  alias_attribute :incorporated, :incorporatedind
  
  alias_attribute :date_transferred, :datetransferred
      
  validates_inclusion_of :rainfall_last24, :in => self.rainfall_last24_options, :allow_nil => true, :allow_blank => true
  validates_inclusion_of :weather_conditions, :in => self.weather_conditions_options, :allow_nil => true, :allow_blank => true
  validates_inclusion_of :water_level, :in => self.water_level_options, :allow_nil => true, :allow_blank => true
  validates_presence_of  :aquatic_site, :aquatic_activity, :agency, :aquatic_activity_method, :start_date     
  
end
