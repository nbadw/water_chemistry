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
  should_have_many :recorded_observations, :samples
  
  should_require_attributes :aquatic_site, :agency, :aquatic_activity, :aquatic_activity_method, :start_date
  
  should "create a valid record from exemplar" do
    exemplar = AquaticActivityEvent.spawn
    assert exemplar.valid?, exemplar.errors.full_messages.to_sentence
  end
  
  should "allow basic CRUD operations" do
    assert AquaticActivityEvent.spawn.save    
    aquatic_activity_event = AquaticActivityEvent.first
    assert_not_nil aquatic_activity_event
    aquatic_activity_event.crew = 'Tester 1, Tester 2'
    assert aquatic_activity_event.save
    aquatic_activity_event.destroy
    assert !AquaticActivityEvent.exists?(aquatic_activity_event.id)
  end 
  
  should "return a recorded observation if it exists when requesting water_level" do
    event = AquaticActivityEvent.spawn
    water_level_observation = Observation.new    
    recorded_water_level_observation = RecordedObservation.new
    
    Observation.expects(:water_level).returns(water_level_observation)
    recorded_water_level_observation.expects(:observation).returns(water_level_observation)    
    event.expects(:recorded_observations).returns([recorded_water_level_observation])
    
    assert_equal recorded_water_level_observation, event.water_level
  end
  
  should "return nil when requesting water_level and no recorded observation exists" do
    event = AquaticActivityEvent.spawn
    assert event.recorded_observations.empty?
    assert_nil event.water_level
  end
  
  should "record a water level observation when setting water_level" do
    event = AquaticActivityEvent.spawn
    water_level_observation = Observation.new    
    
    Observation.expects(:water_level).at_least_once.returns(water_level_observation)
    
    event.water_level = 5    
    
    assert_equal 1, event.recorded_observations.size
    assert event.water_level.is_a?(RecordedObservation)
    assert_equal 5, event.water_level.value_observed
    assert_equal water_level_observation, event.water_level.observation
  end
  
  should "return a recorded observation if it exists when requesting weather_conditions" do
    event = AquaticActivityEvent.spawn
    weather_conditions_observation = Observation.new    
    recorded_weather_conditions_observation = RecordedObservation.new
    
    Observation.expects(:weather_conditions).returns(weather_conditions_observation)
    recorded_weather_conditions_observation.expects(:observation).returns(weather_conditions_observation)    
    event.expects(:recorded_observations).returns([recorded_weather_conditions_observation])
    
    assert_equal recorded_weather_conditions_observation, event.weather_conditions
  end
  
  should "return nil when requesting weather_conditions and no recorded observation exists" do
    event = AquaticActivityEvent.spawn
    assert event.recorded_observations.empty?
    assert_nil event.weather_conditions
  end
  
  should "record a weather conditions observation when setting weather_conditions" do
    event = AquaticActivityEvent.spawn
    weather_conditions_observation = Observation.new      
    
    Observation.expects(:weather_conditions).at_least_once.returns(weather_conditions_observation)
    
    event.weather_conditions = 5    
    
    assert_equal 1, event.recorded_observations.size
    assert event.weather_conditions.is_a?(RecordedObservation)
    assert_equal 5, event.weather_conditions.value_observed
    assert_equal weather_conditions_observation, event.weather_conditions.observation
  end
end
