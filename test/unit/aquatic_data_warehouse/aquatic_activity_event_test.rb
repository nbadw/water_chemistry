require File.dirname(__FILE__) + '/../../test_helper'

class AquaticActivityEventTest < ActiveSupport::TestCase
  should_use_table "tblAquaticActivity"
  should_use_primary_key "AquaticActivityID"
  
  should_have_db_column "Agency2Cd", :limit => 4, :type => :string
  should_have_db_column "Agency2Contact", :limit => 50, :type => :string
  should_have_db_column "AgencyCd", :limit => 4, :type => :string
  should_have_db_column "AirTemp_C", :type => :float
  should_have_db_column "AquaticActivityEndDate", :limit => 10, :type => :string
  should_have_db_column "AquaticActivityEndTime", :limit => 6, :type => :string
  should_have_db_column "AquaticActivityLeader", :limit => 50, :type => :string
  should_have_db_column "AquaticActivityStartDate", :limit => 10, :type => :string
  should_have_db_column "AquaticActivityStartTime", :limit => 6, :type => :string
  should_have_db_column "AquaticMethodCd", :type => :integer
  should_have_db_column "AquaticProgramID", :type => :integer
  should_have_db_column "AquaticSiteID", :type => :integer
  should_have_db_column "Comments", :limit => 250, :type => :string
  should_have_db_column "Crew", :limit => 50, :type => :string
  should_have_db_column "DateEntered", :type => :datetime
  should_have_db_column "DateTransferred", :type => :datetime
  should_have_db_column "IncorporatedInd", :type => :boolean
  should_have_db_column "oldAquaticSiteID", :type => :integer
  should_have_db_column "PermitNo", :limit => 20, :type => :string
  should_have_db_column "PrimaryActivityInd", :type => :boolean
  should_have_db_column "Project", :limit => 100, :type => :string
  should_have_db_column "Siltation", :limit => 50, :type => :string
  should_have_db_column "TempAquaticActivityID", :type => :integer
  should_have_db_column "WaterLevel", :limit => 6, :type => :string
  should_have_db_column "WaterLevel_AM_cm", :limit => 50, :type => :string
  should_have_db_column "WaterLevel_cm", :limit => 50, :type => :string
  should_have_db_column "WaterLevel_PM_cm", :limit => 50, :type => :string
  should_have_db_column "WaterTemp_C", :type => :float
  should_have_db_column "WeatherConditions", :limit => 50, :type => :string
  should_have_db_column "Year", :limit => 4, :type => :string

  should_have_instance_methods :agency2_cd, :agency2_contact, :agency_cd, 
    :air_temp_c, :aquatic_activity_end_date, :aquatic_activity_end_time,
    :aquatic_activity_id, :aquatic_activity_leader, :aquatic_activity_start_date,
    :aquatic_activity_start_time, :aquatic_method_cd, :aquatic_program_id,
    :aquatic_site_id, :comments, :crew, :date_entered, :date_transferred,
    :incorporated_ind, :old_aquatic_site_id, :permit_no, :primary_activity_ind,
    :project, :siltation, :temp_aquatic_activity_id, :water_level, 
    :water_level_am_cm, :water_level_cm, :water_level_pm_cm, :water_temp_c,
    :weather_conditions, :year
  
  should_belong_to :aquatic_activity, :aquatic_site, :agency, :secondary_agency, :aquatic_activity_method    
  should_require_attributes :aquatic_site, :agency, :aquatic_activity, :aquatic_activity_method
  should_eventually "require attribute :start_date"
     
  context "with an existing record" do
    setup do
      #@tbl_aquatic_activity = AquaticActivityEvent.generate!      
    end
    
    should_eventually '_allow_values_for :rainfall_last24, *AquaticActivityEvent.rainfall_last24_options'
    should_eventually '_allow_values_for :weather_conditions, *AquaticActivityEvent.weather_conditions_options'
    should_eventually '_allow_values_for :water_level, *AquaticActivityEvent.water_level_options'
  end
end
