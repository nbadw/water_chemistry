require File.dirname(__FILE__) + '/../../test_helper'

class EnvironmentalSurveyFieldMeasureTest < ActiveSupport::TestCase
  should_use_table "tblEnvironmentalSurveyFieldMeasures"
  should_use_primary_key "FieldMeasureID"

  should_have_db_column "AquaticActivityID", :type => :integer
  should_have_db_column "StreamCover", :limit => 10, :type => :string
  should_have_db_column "BankStability", :limit => 20, :type => :string
  should_have_db_column "BankSlope_Rt", :type => :integer
  should_have_db_column "BankSlope_Lt", :type => :integer
  should_have_db_column "StreamType", :limit => 10, :type => :string
  should_have_db_column "StreamTypeSupp", :limit => 30, :type => :string
  should_have_db_column "SuspendedSilt", :null => false, :type => :boolean  
  should_have_db_column "EmbeddedSub", :null => false, :type => :boolean
  should_have_db_column "AquaticPlants", :null => false, :type => :boolean
  should_have_db_column "Algae", :null => false, :type => :boolean
  should_have_db_column "Petroleum", :null => false, :type => :boolean
  should_have_db_column "Odor", :null => false, :type => :boolean
  should_have_db_column "Foam", :null => false, :type => :boolean
  should_have_db_column "DeadFish", :null => false, :type => :boolean
  should_have_db_column "Other", :null => false, :type => :boolean
  should_have_db_column "OtherSupp", :limit => 50, :type => :string
  should_have_db_column "Length_m", :type => :float
  should_have_db_column "AveWidth_m", :type => :float
  should_have_db_column "AveDepth_m", :type => :float
  should_have_db_column "Velocity_mpers", :type => :float
  should_have_db_column "WaterClarity", :limit => 16, :type => :string
  should_have_db_column "WaterColor", :limit => 10, :type => :string
  should_have_db_column "Weather_Past", :limit => 20, :type => :string
  should_have_db_column "Weather_Current", :limit => 20, :type => :string
  should_have_db_column "RZ_Lawn_Lt", :type => :integer
  should_have_db_column "RZ_Lawn_Rt", :type => :float
  should_have_db_column "RZ_RowCrop_Lt", :type => :integer
  should_have_db_column "RZ_RowCrop_Rt", :type => :integer
  should_have_db_column "RZ_ForageCrop_Lt", :type => :integer
  should_have_db_column "RZ_ForageCrop_Rt", :type => :integer
  should_have_db_column "RZ_Shrubs_Lt", :type => :integer
  should_have_db_column "RZ_Shrubs_Rt", :type => :integer
  should_have_db_column "RZ_Hardwood_Lt", :type => :integer
  should_have_db_column "RZ_Hardwood_Rt", :type => :integer
  should_have_db_column "RZ_Softwood_Lt", :type => :integer
  should_have_db_column "RZ_Softwood_Rt", :type => :integer
  should_have_db_column "RZ_Mixed_Lt", :type => :integer
  should_have_db_column "RZ_Mixed_Rt", :type => :integer
  should_have_db_column "RZ_Meadow_Lt", :type => :integer
  should_have_db_column "RZ_Meadow_Rt", :type => :integer
  should_have_db_column "RZ_Wetland_Lt", :type => :integer
  should_have_db_column "RZ_Wetland_Rt", :type => :integer
  should_have_db_column "RZ_Altered_Lt", :type => :integer
  should_have_db_column "RZ_Altered_Rt", :type => :integer
  should_have_db_column "ST_TimeofDay", :limit => 5, :type => :string
  should_have_db_column "ST_DissOxygen", :type => :float
  should_have_db_column "ST_AirTemp_C", :type => :float
  should_have_db_column "ST_WaterTemp_C", :type => :float
  should_have_db_column "ST_pH", :type => :float
  should_have_db_column "ST_Conductivity", :type => :float
  should_have_db_column "ST_Flow_cms", :type => :float
  should_have_db_column "ST_DELGFieldNo", :limit => 50, :type => :string
  should_have_db_column "GW1_TimeofDay", :limit => 5, :type => :string
  should_have_db_column "GW1_DissOxygen", :type => :float
  should_have_db_column "GW1_AirTemp_C", :type => :float
  should_have_db_column "GW1_WaterTemp_C", :type => :float
  should_have_db_column "GW1_pH", :type => :float
  should_have_db_column "GW1_Conductivity", :type => :float
  should_have_db_column "GW1_Flow_cms", :type => :float
  should_have_db_column "GW1_DELGFieldNo", :limit => 50, :type => :string
  should_have_db_column "GW2_TimeofDay", :limit => 5, :type => :string
  should_have_db_column "GW2_DissOxygen", :type => :float
  should_have_db_column "GW2_AirTemp_C", :type => :float
  should_have_db_column "GW2_WaterTemp_C", :type => :float
  should_have_db_column "GW2_pH", :type => :float
  should_have_db_column "GW2_Conductivity", :type => :float
  should_have_db_column "GW2_Flow_cms", :type => :float
  should_have_db_column "GW2_DELGFieldNo", :limit => 50, :type => :string
end
