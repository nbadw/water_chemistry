require File.dirname(__FILE__) + '/../../test_helper'

class DrainageUnitTest < ActiveSupport::TestCase
  should_use_table       'tblDraingeUnit'
  should_use_primary_key 'DrainageCd', :type => :string, :limit => 17
  
  (1..6).each do |i|
    should_have_db_column "Level#{i}No", :type => :string, :limit => 2
    should_have_db_column "Level#{i}Name", :type => :string, :limit => (i == 1 ? 40 : 50)
    should_have_instance_methods "level#{i}_no", "level#{i}_name"
  end
  
  should_have_db_column "UnitName", :type => :string, :limit => 55
  should_have_db_column "UnitType", :type => :string, :limit => 4
  should_have_db_column "BorderInd", :type => :string, :limit => 1
  should_have_db_column "StreamOrder", :type => :integer, :limit => 5
  should_have_db_column "Area_ha", :type => :float
  should_have_db_column "Area_percent", :type => :float
  
  should_have_instance_methods :unit_name, :unit_type, :border_ind, :stream_order, :area_ha, :area_percent
  
  should_have_many :waterbodies
end
