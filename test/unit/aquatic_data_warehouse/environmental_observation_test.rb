require File.dirname(__FILE__) + '/../../test_helper'

class EnvironmentalObservationTest < ActiveSupport::TestCase
  should_use_table "tblEnvironmentalObservations"
  should_use_primary_key "EnvObservationID"
  
  should_have_db_column "AquaticActivityID", :type => :integer
  should_have_db_column "ObservationGroup", :limit => 50, :type => :string
  should_have_db_column "Observation", :limit => 50, :type => :string
  should_have_db_column "ObservationSupp", :limit => 50, :type => :string
  should_have_db_column "PipeSize_cm", :type => :integer
  should_have_db_column "FishPassageObstructionInd", :null => false, :type => :boolean

  should_have_instance_methods :aquatic_activity_id, :observation_group, :observation,
    :observation_supp, :pipe_size_cm, :fish_passage_obstruction_ind, :fish_passage_obstruction_ind?
end
