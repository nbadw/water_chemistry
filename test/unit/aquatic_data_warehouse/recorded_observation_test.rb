require File.dirname(__FILE__) + '/../../test_helper'

class RecordedObservationTest < ActiveSupport::TestCase
  should_use_table "tblObservations"
  should_use_primary_key "ObservationID"
  
  should_have_db_column "AquaticActivityID", :type => :integer
  should_have_db_column "OandMCd", :type => :integer
  should_have_db_column "OandM_Details", :type => :string, :limit => 150
  should_have_db_column "OandMValuesCd", :type => :integer
  should_have_db_column "FishPassageObstructionInd", :type => :boolean
  
  should_have_instance_methods :observation_id, :aquatic_activity_id, :oand_m_cd,
    :oand_m_details, :oand_m_values_cd, :fish_passage_obstruction_ind, :value_observed
  
  should_belong_to :aquatic_activity_event
  should_belong_to :observation
  should_belong_to :observable_value
  
  should_require_attributes :aquatic_activity_event, :observation
  
  should "be able to create" do
    RecordedObservation.generate!
  end
end
