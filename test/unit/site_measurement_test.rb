require File.dirname(__FILE__) + '/../test_helper'

class SiteMeasurementTest < ActiveSupport::TestCase
  should_belong_to :aquatic_site, :aquatic_activity_event, :measurement, :instrument, :unit_of_measure
  should_require_attributes :aquatic_site, :aquatic_activity_event, :measurement, :instrument, :unit_of_measure, :value_measured
  should_have_db_column :aquatic_activity_event_id
  
  context "with an existing record" do
    setup { @site_measurement = SiteMeasurement.generate! }
    
    should_allow_values_for :bank, "Left", "Right", nil
    should_only_allow_numeric_values_for :value_measured
  end
  
  context "when calculating the amount of substrate accounted for in an aquatic activity event" do
    setup do
      @aquatic_activity_event = AquaticActivityEvent.generate!
    end
    
    should "return 0 if there are no site measurements recorded" do
      assert_equal 0, SiteMeasurement.calculate_substrate_accounted_for(@aquatic_activity_event.id)
    end
    
    should "return 0 if there are no substrate site measurements recorded" do
      5.times do
        measurement = Measurement.generate!(:grouping => 'Non-substrate')
        SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => measurement, :value_measured => 1)
      end
      assert_equal 0, SiteMeasurement.calculate_substrate_accounted_for(@aquatic_activity_event.id)
    end
    
    should "return the correct sum of the values of any substrate site measurements recorded" do
      5.times do
        measurement = Measurement.generate!(:grouping => Measurement.grouping_for_substrate_measurements )
        SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => measurement, :value_measured => 1)
      end
      assert_equal 5, SiteMeasurement.calculate_substrate_accounted_for(@aquatic_activity_event.id)
    end
  end
end
