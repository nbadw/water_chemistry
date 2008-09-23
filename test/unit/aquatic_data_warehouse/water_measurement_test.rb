require File.dirname(__FILE__) + '/../../test_helper'

class WaterMeasurementTest < ActiveSupport::TestCase
  should_use_table "tblWaterMeasurement"
  should_use_primary_key "WaterMeasurementID"
  
  should_have_db_column 'AquaticActivityID', :type => :integer
  should_have_db_column 'TempAquaticActivityID', :type => :integer
  should_have_db_column 'TempDataID', :type => :integer
  should_have_db_column 'TemperatureLoggerID', :type => :integer
  should_have_db_column 'HabitatUnitID', :type => :integer
  should_have_db_column 'SampleID', :type => :integer
  should_have_db_column 'WaterSourceCd', :type => :string, :limit => 50
  should_have_db_column 'WaterDepth_m', :type => :float
  should_have_db_column 'TimeofDay', :type => :string, :limit => 5
  should_have_db_column 'OandMCd', :type => :integer
  should_have_db_column 'InstrumentCd', :type => :integer
  should_have_db_column 'Measurement', :type => :float
  should_have_db_column 'UnitofMeasureCd', :type => :integer
  should_have_db_column 'QualifierCd', :type => :string, :limit => 20
  should_have_db_column 'Comment', :type => :string, :limit => 255
  
  should_have_instance_methods :aquatic_activity_id, :temp_aquatic_activity_id, :temp_data_id, :temperature_logger_id, :habitat_unit_id,
    :sample_id, :water_source_cd, :water_depth_m, :timeof_day, :oand_m_cd, :instrument_cd, :measurement, :unitof_measure_cd, :qualifier_cd, :comment
  
  should_belong_to :o_and_m
  should_belong_to :instrument
  should_belong_to :unit_of_measure  
  should_belong_to :sample
  should_belong_to :qualifier
  
  should_require_attributes :o_and_m, :measurement
  should_only_allow_numeric_values_for :measurement
  
  should_eventually "create/read/update/delete" do
#    agency = Agency.spawn
#    assert agency.save
#    db_record = Agency.find(agency.id)
#    assert_equal agency.id, db_record.id
#    agency.name = agency.name.to_s.reverse
#    assert agency.save
#    assert agency.destroy
#    assert !Agency.exists?(agency.id)
  end
end
