require File.dirname(__FILE__) + '/../../test_helper'

class WaterbodyTest < ActiveSupport::TestCase
  should_use_table       'tblWaterBody'
  should_use_primary_key 'WaterBodyID'
  
  should_have_db_column "DateEntered", :type => :datetime
  should_have_db_column "DateModified", :type => :datetime
  should_have_db_column "DrainageCd", :limit => 17, :type => :string
  should_have_db_column "FlowIntoDrainageCd", :limit => 17, :type => :string
  should_have_db_column "FlowsIntoWaterBodyID", :type => :float
  should_have_db_column "FlowsIntoWaterBodyName", :limit => 40, :type => :string
  should_have_db_column "Surveyed_Ind", :limit => 1, :type => :string
  should_have_db_column "WaterBodyComplexID", :type => :integer
  should_have_db_column "WaterBodyName", :limit => 55, :type => :string
  should_have_db_column "WaterBodyName_Abrev", :limit => 40, :type => :string
  should_have_db_column "WaterBodyName_Alt", :limit => 40, :type => :string
  should_have_db_column "WaterBodyTypeCd", :limit => 4, :type => :string
  
  should_have_instance_methods :date_entered, :date_modified, :drainage_cd, :flow_into_drainage_cd,
    :flows_into_water_body_id, :flows_into_water_body_name, :surveyed_ind, :water_body_complex_id, 
    :water_body_name, :water_body_name_abrev, :water_body_name_alt, :water_body_type_cd
  
  should_have_many :aquatic_sites
  should_belong_to :drainage_unit
  
  should_eventually "test the search function"  
end
