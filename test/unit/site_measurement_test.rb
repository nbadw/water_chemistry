require File.dirname(__FILE__) + '/../test_helper'

class SiteMeasurementTest < ActiveSupport::TestCase
  should_eventually '_belong_to :aquatic_site, :aquatic_activity_event, :measurement, :instrument, :unit_of_measure'
  should_eventually '_require_attributes :aquatic_site, :aquatic_activity_event, :measurement, :instrument, :unit_of_measure, :value_measured'
  should_eventually '_have_db_column :aquatic_activity_event_id'
  
  context "with an existing record" do
    setup do
      #site_measurement = SiteMeasurement.generate!
      #assert !site_measurement.measurement.bank_measurement?
    end    
    should_eventually '_only_allow_numeric_values_for :value_measured'
  end
  
  context "with an existing bank measurement record" do
    setup do
      #site_measurement = SiteMeasurement.generate!(:bank => SiteMeasurement::LEFT_BANK, :measurement => Measurement.generate!(:bank_measurement => true))
      #assert_not_nil site_measurement.bank 
      #assert site_measurement.measurement.bank_measurement?
    end    
    should_eventually '_allow_values_for :bank, [SiteMeasurement::LEFT_BANK, SiteMeasurement::RIGHT_BANK]'
  end
  
  context "when calculating the amount of substrate accounted for in an aquatic activity event" do
    setup { } #@aquatic_activity_event = AquaticActivityEvent.generate! }
        
    should_eventually "return 0 if there are no substrate site measurements recorded" do
      measurement = Measurement.generate!(:grouping => 'Non-substrate')
      5.times { SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => measurement, :value_measured => 1.1) }
      assert_equal 0, SiteMeasurement.calculate_substrate_accounted_for(@aquatic_activity_event.id)
    end
    
    should_eventually "return the correct sum of the values of any substrate site measurements recorded" do
      measurement = Measurement.generate!(:grouping => Measurement.grouping_for_substrate_measurements )
      5.times { SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => measurement, :value_measured => 1.1) }
      assert_equal 5.5, SiteMeasurement.calculate_substrate_accounted_for(@aquatic_activity_event.id)
    end
  end
  
  context "when calculating the amount of stream accounted for in an aquatic activity event" do
    setup {} # { @aquatic_activity_event = AquaticActivityEvent.generate! }
        
    should_eventually "return 0 if there are no stream site measurements recorded" do
      measurement = Measurement.generate!(:grouping => 'Non-stream')
      5.times { SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => measurement, :value_measured => 1.1) }
      assert_equal 0, SiteMeasurement.calculate_stream_accounted_for(@aquatic_activity_event.id)
    end
    
    should_eventually "return the correct sum of the values of any stream site measurements recorded" do
      measurement = Measurement.generate!(:grouping => Measurement.grouping_for_stream_measurements )
      5.times { SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => measurement, :value_measured => 1.1) }
      assert_equal 5.5, SiteMeasurement.calculate_stream_accounted_for(@aquatic_activity_event.id)
    end
  end
  
  context "when calculating the amount of bank accounted for all bank measurements in an aquatic activity event" do
    setup {} # { @aquatic_activity_event = AquaticActivityEvent.generate! }
    
    should_eventually "return an empty hash if there are no bank measurements" do
      5.times do
        measurement = Measurement.generate!(:bank_measurement => false)
        SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => measurement, :value_measured => 1.1)
      end
      
      assert_equal 0, SiteMeasurement.calculate_bank_accounted_for(@aquatic_activity_event.id).size
    end
    
    should_eventually "return a hash of summed values for all bank measurements" do
      bank_measurement_1 = Measurement.generate!(:bank_measurement => true)
      bank_measurement_2 = Measurement.generate!(:bank_measurement => true)
      bank_measurement_3 = Measurement.generate!(:bank_measurement => true)
      
      SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => bank_measurement_1, :value_measured => 1, :bank => 'Left')
      
      SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => bank_measurement_2, :value_measured => 1.1, :bank => 'Left')
      SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => bank_measurement_2, :value_measured => 1.1, :bank => 'Right')
      
      SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :measurement => bank_measurement_3, :value_measured => 3, :bank => 'Left')
      
      bank_accounted_for = SiteMeasurement.calculate_bank_accounted_for(@aquatic_activity_event.id)
      assert_equal 3, bank_accounted_for.size
      assert_equal 1, bank_accounted_for[bank_measurement_1.name]      
      assert_equal 2.2, bank_accounted_for[bank_measurement_2.name]
      assert_equal 3, bank_accounted_for[bank_measurement_3.name]
    end
  end
end
