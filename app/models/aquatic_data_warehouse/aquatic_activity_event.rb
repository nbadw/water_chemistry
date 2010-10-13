# == Schema Information
# Schema version: 20081127150314
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
#  created_at               :datetime        
#  updated_at               :datetime        
#  created_by               :integer(11)     
#  updated_by               :integer(11)     
#

class AquaticActivityEvent < AquaticDataWarehouse::BaseTbl  
  set_table_name  "tblAquaticActivity"
  set_primary_key "AquaticActivityID"
     
  belongs_to :aquatic_activity, :foreign_key => 'AquaticActivityCd'
  belongs_to :aquatic_site, :foreign_key => 'AquaticSiteID'
  belongs_to :agency, :foreign_key => 'AgencyCd'
  belongs_to :secondary_agency, :class_name => 'Agency', :foreign_key => 'Agency2Cd'
  belongs_to :aquatic_activity_method, :foreign_key => 'AquaticMethodCd'
  has_many   :recorded_observations, :foreign_key => 'AquaticActivityID', :dependent => :destroy
  has_many   :samples, :foreign_key => 'AquaticActivityID', :dependent => :destroy
         
  validates_presence_of  :aquatic_site, :aquatic_activity, :agency, :start_date

  # TODO: needs to be moved into a water_chemistry_sampling_event model...
  # validates_presence_of :aquatic_activity_method
  
  def to_label
    :aquatic_activity_event_to_label.l_with_args({ :id => id })
  end

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
      value = value.empty? ? nil : DateTime.parse(value).to_s(:adw)
    else
      value = nil
    end
    write_attribute("AquaticActivityStartDate", value)    
  end  
  
  def water_level
    recorded_observations.to_a.find { |rec_obs| rec_obs.observation == Observation.water_level }
  end
  
  def water_level=(value)  
    rec_obs = RecordedObservation.new(:observation => Observation.water_level)
    rec_obs.value_observed = value
    recorded_observations << rec_obs
  end
  
  def weather_conditions
    recorded_observations.to_a.find { |rec_obs| rec_obs.observation == Observation.weather_conditions }
  end
  
  def weather_conditions=(value)  
    rec_obs = RecordedObservation.new(:observation => Observation.weather_conditions)
    rec_obs.value_observed = value
    recorded_observations << rec_obs
  end
  
  def current_agency_authorized_for_update?
    current_agency_authorized_for_update_or_destroy?
  end
  
  def current_agency_authorized_for_destroy?
    current_agency_authorized_for_update_or_destroy?
  end
  
  def current_agency_authorized_for_update_or_destroy?
    if existing_record_check?
      !!current_agency && (current_agency == agency || current_agency == secondary_agency)
    else
      !!current_agency 
    end
  end
    
  def self.count_attached(aquatic_site, aquatic_activity)
    aquatic_site_id = aquatic_site.is_a?(AquaticSite) ? aquatic_site.id : aquatic_site.to_i
    aquatic_activity_id = aquatic_activity.is_a?(AquaticActivity) ? aquatic_activity.id : aquatic_activity.to_i
    self.count :all, :conditions => ['AquaticSiteID = ? AND AquaticActivityCd = ?', aquatic_site_id, aquatic_activity_id]
  end
end
