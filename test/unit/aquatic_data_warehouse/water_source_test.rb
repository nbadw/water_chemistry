require File.dirname(__FILE__) + '/../../test_helper'

class WaterSourceTest < ActiveSupport::TestCase
  should_use_table 'cdWaterSource'
  should_use_primary_key 'WaterSourceCd', :type => :string, :limit => 4
  
  should_have_db_column 'WaterSource', :type => :string, :limit => 20
  should_have_db_column 'WaterSourceType', :type => :string, :limit => 20
  should_have_audit_fields
  
  should_have_instance_methods :water_source_cd, :water_source, :water_source_type
  
  should_alias_attribute :water_source, :name
end
