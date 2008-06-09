require File.dirname(__FILE__) + '/../test_helper'

class TblAquaticActivityTest < ActiveSupport::TestCase
  should_belong_to :aquatic_activity_code
  should_belong_to :aquatic_site
  should_belong_to :agency
  should_belong_to :agency2
  should_belong_to :aquatic_activity_method_code
  
  context "with an existing record" do
    setup do
      @tbl_aquatic_activity = TblAquaticActivity.generate!
    end
    
    should_allow_values_for :rainfall_last24, TblAquaticActivity.rainfall_last24_options
    should_allow_values_for :weather_conditions, TblAquaticActivity.weather_conditions_options
    should_allow_values_for :water_level, TblAquaticActivity.water_level_options
  end
end
