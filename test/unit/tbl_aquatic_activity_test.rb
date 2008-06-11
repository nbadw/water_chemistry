require File.dirname(__FILE__) + '/../test_helper'

class TblAquaticActivityTest < ActiveSupport::TestCase
  should_belong_to :aquatic_activity_code
  should_belong_to :aquatic_site
  should_belong_to :agency
  should_belong_to :agency2
  should_belong_to :aquatic_activity_method_code
  
  should_require_attributes :aquatic_site, :agency, :aquatic_activity_code, 
    :aquatic_activity_method_code, :aquaticactivitystartdate  
  
  context "with an existing record" do
    setup do
      @tbl_aquatic_activity = TblAquaticActivity.generate!      
    end
    
    should_allow_values_for :rainfall_last24, TblAquaticActivity.rainfall_last24_options
    should_allow_values_for :weather_conditions, TblAquaticActivity.weather_conditions_options
    should_allow_values_for :water_level, TblAquaticActivity.water_level_options
  end
  
#  context "when calling start_date" do
#    should "return null when startdate and starttime are null"
#    should "be startdate when only startdate is present"
#    should "be null when only starttime is present"
#    should "be startdate at january 01 when startdate is just the year"
#    should "when startdate is year and starttime is present"
#  end
  
  should "correctly parse aquaticactivitystartdate and aquaticactivitystarttime into a date object when getting start_date" do
    aquatic_activity = TblAquaticActivity.new(:aquaticactivitystartdate => '2008/01/31', :aquaticactivitystarttime => '3:37')
    expected_date = DateTime.parse "2008/01/31 3:37"
    assert_equal expected_date, aquatic_activity.start_date
  end
  
  should "update aquaticactivitystartdate and aquaticactivitystarttime when setting start_date" do
    aquatic_activity = TblAquaticActivity.new
    aquatic_activity.start_date = DateTime.parse "2008/01/31 3:37"
    assert_equal '2008/01/31', aquatic_activity.aquaticactivitystartdate
    assert_equal '03:37', aquatic_activity.aquaticactivitystarttime
  end
  
  should "correctly parse aquaticactivityenddate and aquaticactivityendtime into a date object when getting end_date" do
    aquatic_activity = TblAquaticActivity.new(:aquaticactivityenddate => '2008/12/31', :aquaticactivityendtime => '7:37')
    expected_date = DateTime.parse "2008/12/31 7:37"
    assert_equal expected_date, aquatic_activity.end_date
  end
  
  should "update aquaticactivityenddate and aquaticactivityendtime when setting end_date" do
    aquatic_activity = TblAquaticActivity.new
    aquatic_activity.end_date = DateTime.parse "2008/12/31 7:37"
    assert_equal '2008/12/31', aquatic_activity.aquaticactivityenddate
    assert_equal '07:37', aquatic_activity.aquaticactivityendtime
  end
end
