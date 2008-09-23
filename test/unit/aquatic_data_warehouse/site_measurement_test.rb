require File.dirname(__FILE__) + '/../../test_helper'

class SiteMeasurementTest < ActiveSupport::TestCase
  should_use_table 'tblSiteMeasurement'
  should_use_primary_key 'SiteMeasurementID'
  
  should_have_db_column 'AquaticActivityID', :type => :integer
  should_have_db_column 'OandMCd', :type => :integer
  should_have_db_column 'OandM_Other', :type => :string, :limit => 20
  should_have_db_column 'Bank', :type => :string, :limit => 10
  should_have_db_column 'InstrumentCd', :type => :integer
  should_have_db_column 'Measurement', :type => :float
  should_have_db_column 'UnitofMeasureCd', :type => :integer

  should_have_instance_methods :site_measurement_id, :aquatic_activity_id, :oand_m_cd,
    :oand_m_other, :bank, :instrument_cd, :measurement, :unitof_measure_cd
  
  should_belong_to :o_and_m
  should_belong_to :instrument
  should_belong_to :unit_of_measure
  should_belong_to :aquatic_activity_event
  
  should_require_attributes :aquatic_activity_event, :o_and_m, :instrument, 
    :unit_of_measure, :measurement
  should_only_allow_numeric_values_for :measurement
  
  context "when validating bank value" do    
    should "have no errors on the bank attribute if o_and_m measurement is not a bank measurement and bank side is not present" do
      o_and_m = Measurement.new
      o_and_m.expects(:bank_measurement?).returns(false)
      site_measurement = SiteMeasurement.new(:bank => nil, :o_and_m => o_and_m)
      site_measurement.valid?
      assert_nil site_measurement.errors.on(:bank)
    end
    
    should "have an error on the bank attribute if o_and_m measurement is a bank measurement and bank side is not present" do
      o_and_m = Measurement.new
      o_and_m.expects(:bank_measurement?).returns(true)
      site_measurement = SiteMeasurement.new(:bank => nil, :o_and_m => o_and_m)
      site_measurement.valid?
      assert site_measurement.errors.invalid?(:bank)
    end
    
    should "have no errors on the bank attribute if o_and_m Measurement is a bank measurement and the bank side is Left or Right" do
      o_and_m = Measurement.new
      o_and_m.expects(:bank_measurement?).times(2).returns(true)
      site_measurement = SiteMeasurement.new(:o_and_m => o_and_m)
      site_measurement.bank = SiteMeasurement::LEFT_BANK
      site_measurement.valid?
      assert_nil site_measurement.errors.on(:bank)
      
      site_measurement.bank = SiteMeasurement::RIGHT_BANK
      site_measurement.valid?
      assert_nil site_measurement.errors.on(:bank)
    end
  end

  
  context "when calculating the amount of substrate accounted for in an aquatic activity event" do
    setup { @aquatic_activity_event = AquaticActivityEvent.generate! }
        
    should "return 0 if there are no substrate site measurements recorded" do
      measurement = Measurement.generate!(:group => 'Non-substrate')
      5.times { SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :o_and_m => measurement, :measurement => 1.1) }
      assert_equal 0, SiteMeasurement.calculate_substrate_accounted_for(@aquatic_activity_event.id)
    end
    
    should "return the correct sum of the values of any substrate site measurements recorded" do
      measurement = Measurement.generate!(:group => Measurement.substrate_measurements_group )
      5.times { SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :o_and_m => measurement, :measurement => 1.1) }
      assert_equal 5.5, SiteMeasurement.calculate_substrate_accounted_for(@aquatic_activity_event.id)
    end
  end
  
  context "when calculating the amount of stream accounted for in an aquatic activity event" do
    setup { @aquatic_activity_event = AquaticActivityEvent.generate! }
        
    should "return 0 if there are no stream site measurements recorded" do
      measurement = Measurement.generate!(:group => 'Non-stream')
      5.times { SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :o_and_m => measurement, :measurement => 1.1) }
      assert_equal 0, SiteMeasurement.calculate_stream_accounted_for(@aquatic_activity_event.id)
    end
    
    should "return the correct sum of the values of any stream site measurements recorded" do
      measurement = Measurement.generate!(:group => Measurement.stream_measurements_group )
      5.times { SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :o_and_m => measurement, :measurement => 1.1) }
      assert_equal 5.5, SiteMeasurement.calculate_stream_accounted_for(@aquatic_activity_event.id)
    end
  end

  context "when calculating the amount of bank accounted for all bank measurements in an aquatic activity event" do
    setup { @aquatic_activity_event = AquaticActivityEvent.generate! }
    
    should "return an empty hash if there are no bank measurements" do
      5.times do
        measurement = Measurement.generate!(:bank_ind => false)
        SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :o_and_m => measurement, :measurement => 1.1)
      end
      
      assert_equal 0, SiteMeasurement.calculate_bank_accounted_for(@aquatic_activity_event.id).size
    end
    
    should "return a hash of summed values for all bank measurements" do
      bank_measurement_1 = Measurement.generate!(:bank_ind => true)
      bank_measurement_2 = Measurement.generate!(:bank_ind => true)
      bank_measurement_3 = Measurement.generate!(:bank_ind => true)
      
      SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :o_and_m => bank_measurement_1, :measurement => 1, :bank => SiteMeasurement::LEFT_BANK)
      
      SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :o_and_m => bank_measurement_2, :measurement => 1.1, :bank => SiteMeasurement::LEFT_BANK)
      SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :o_and_m => bank_measurement_2, :measurement => 1.1, :bank => SiteMeasurement::RIGHT_BANK)
      
      SiteMeasurement.generate!(:aquatic_activity_event => @aquatic_activity_event, :o_and_m => bank_measurement_3, :measurement => 3, :bank => SiteMeasurement::LEFT_BANK)
      
      bank_accounted_for = SiteMeasurement.calculate_bank_accounted_for(@aquatic_activity_event.id)
      assert_equal 3, bank_accounted_for.size
      assert_equal 1, bank_accounted_for[bank_measurement_1.name]      
      assert_equal 2.2, bank_accounted_for[bank_measurement_2.name]
      assert_equal 3, bank_accounted_for[bank_measurement_3.name]
    end
  end
end
