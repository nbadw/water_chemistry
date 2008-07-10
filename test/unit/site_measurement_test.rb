require File.dirname(__FILE__) + '/../test_helper'

class SiteMeasurementTest < ActiveSupport::TestCase
  should_belong_to :aquatic_site, :aquatic_activity_event, :measurement, :instrument, :unit_of_measure
  should_require_attributes :aquatic_site, :aquatic_activity_event, :measurement, :instrument, :unit_of_measure, :value_measured
  
  context "with an existing record" do
    setup { @site_measurement = SiteMeasurement.generate! }
    
    should_allow_values_for :bank, "Left", "Right", nil
    should_only_allow_numeric_values_for :value_measured
  end
end
