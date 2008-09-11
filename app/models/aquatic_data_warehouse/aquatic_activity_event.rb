# == Schema Information
# Schema version: 1
#
# Table name: tblAquaticActivity
#
#  AquaticActivityID        :integer(10)     not null, primary key
#  TempAquaticActivityID    :integer(10)     
#  Project                  :string(100)     
#  PermitNo                 :string(20)      
#  AquaticProgramID         :integer(10)     
#  AquaticActivityCd        :integer(5)      
#  AquaticMethodCd          :integer(5)      
#  oldAquaticSiteID         :integer(10)     
#  AquaticSiteID            :integer(10)     
#  AquaticActivityStartDate :string(10)      
#  AquaticActivityEndDate   :string(10)      
#  AquaticActivityStartTime :string(6)       
#  AquaticActivityEndTime   :string(6)       
#  Year                     :string(4)       
#  AgencyCd                 :string(4)       
#  Agency2Cd                :string(4)       
#  Agency2Contact           :string(50)      
#  AquaticActivityLeader    :string(50)      
#  Crew                     :string(50)      
#  WeatherConditions        :string(50)      
#  WaterTemp_C              :float(7)        
#  AirTemp_C                :float(7)        
#  WaterLevel               :string(6)       
#  WaterLevel_cm            :string(50)      
#  WaterLevel_AM_cm         :string(50)      
#  WaterLevel_PM_cm         :string(50)      
#  Siltation                :string(50)      
#  PrimaryActivityInd       :boolean(1)      not null
#  Comments                 :string(250)     
#  DateEntered              :datetime        
#  IncorporatedInd          :boolean(1)      not null
#  DateTransferred          :datetime        
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
     
  belongs_to :aquatic_activity, :foreign_key => 'AquaticActivityCd'
  belongs_to :aquatic_site, :foreign_key => 'AquaticSiteID'
  belongs_to :agency, :foreign_key => 'AgencyCd'
  belongs_to :secondary_agency, :class_name => 'Agency', :foreign_key => 'Agency2Cd'
  belongs_to :aquatic_activity_method, :foreign_key => 'AquaticMethodCd'
         
  #validates_inclusion_of :rainfall_last24, :in => self.rainfall_last24_options, :allow_nil => true, :allow_blank => true
  #validates_inclusion_of :weather_conditions, :in => self.weather_conditions_options, :allow_nil => true, :allow_blank => true
  #validates_inclusion_of :water_level, :in => self.water_level_options, :allow_nil => true, :allow_blank => true
  validates_presence_of  :aquatic_site, :aquatic_activity, :agency, :aquatic_activity_method, :start_date     
  
  def start_date
    date = aquatic_activity_start_date        
    date_str = "#{date}, #{year}" if date && year
    date_str = "#{date}" if date && year.nil?
    date_str = "#{year}" if year && date.nil?
    DateTime.parse(date_str).to_s(:adw) if date_str
  end
  
  def start_date=(value)    
    if value.is_a?(DateTime)
      value = value.to_s(:adw)
    elsif value.is_a?(String)
      DateTime.parse(value).to_s(:adw)
    else
      value = nil
    end
    write_attribute("AquaticActivityStartDate", value)    
  end
  
  
  def before_save
    write_attribute('IncorporatedInd', false) if incorporated_ind.nil?
    write_attribute('PrimaryActivityInd', false) if primary_activity_ind.nil?
    return self
  end
end
