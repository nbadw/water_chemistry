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

class AquaticActivityEvent < AquaticDataWarehouse::BaseTbl  
  set_table_name  "tblAquaticActivity"
  set_primary_key "AquaticActivityID"
  
  class << self 
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
     
  belongs_to :aquatic_activity, :foreign_key => 'AquaticActivityID'
  belongs_to :aquatic_site, :foreign_key => 'AquaticSiteID'
  belongs_to :agency, :foreign_key => 'AgencyCd'
  belongs_to :secondary_agency, :class_name => 'Agency', :foreign_key => 'Agency2Cd'
  belongs_to :aquatic_activity_method, :foreign_key => 'AquaticMethodCd'
         
  #validates_inclusion_of :rainfall_last24, :in => self.rainfall_last24_options, :allow_nil => true, :allow_blank => true
  #validates_inclusion_of :weather_conditions, :in => self.weather_conditions_options, :allow_nil => true, :allow_blank => true
  #validates_inclusion_of :water_level, :in => self.water_level_options, :allow_nil => true, :allow_blank => true
  validates_presence_of  :aquatic_site, :aquatic_activity, :agency, :aquatic_activity_method, :start_date     
  
end
