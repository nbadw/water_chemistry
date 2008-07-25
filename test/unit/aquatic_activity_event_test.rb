require File.dirname(__FILE__) + '/../test_helper'

class AquaticActivityEventTest < ActiveSupport::TestCase
  should_belong_to :aquatic_activity, :aquatic_site, :agency, :agency2, :aquatic_activity_method  
  should_require_attributes :aquatic_site, :agency, :aquatic_activity, :aquatic_activity_method, :start_date
  should_define_attributes :project, :permit_no, :aquatic_program_id, :aquatic_activity_id, :aquatic_activity_method_id,
    :aquatic_site_id, :start_date, :end_date, :agency_id, :agency2_id, :agency2_contact, :activity_leader, :crew,
    :weather_conditions, :water_temperature_c, :air_temperature_c, :water_level, :water_level_cm, :morning_water_level_cm,
    :evening_water_level_cm, :siltation, :primary_activity, :comments, :rainfall_last24
  should_define_timestamps
  
  context "with an existing record" do
    setup do
      @tbl_aquatic_activity = AquaticActivityEvent.generate!      
    end
    
    should_allow_values_for :rainfall_last24, AquaticActivityEvent.rainfall_last24_options
    should_allow_values_for :weather_conditions, AquaticActivityEvent.weather_conditions_options
    should_allow_values_for :water_level, AquaticActivityEvent.water_level_options
  end
end
