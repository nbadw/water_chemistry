require File.dirname(__FILE__) + '/../../test_helper'

class SampleTest < ActiveSupport::TestCase
  should_use_table "tblSample"
  should_use_primary_key "SampleID"
  
  should_have_db_column 'AquaticActivityID', :type => :integer
  should_have_db_column 'TempAquaticActivityID', :type => :integer
  should_have_db_column 'LabNo', :type => :string, :limit => 10
  should_have_db_column 'AgencySampleNo', :type => :string, :limit => 10
  should_have_db_column 'SampleDepth_m', :type => :float
  should_have_db_column 'WaterSourceType', :type => :string, :limit => 20
  should_have_db_column 'SampleCollectionMethodCd', :type => :integer
  should_have_db_column 'AnalyzedBy', :type => :string, :limit => 255
  
  should_have_instance_methods :aquatic_activity_id, :temp_aquatic_activity_id, :lab_no,
    :agency_sample_no, :sample_depth_m, :water_source_type, :sample_collection_method_cd,
    :analyzed_by
  
  should_belong_to :aquatic_activity
  should_belong_to :sample_collection_method
  should_have_many :sample_results
  
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
