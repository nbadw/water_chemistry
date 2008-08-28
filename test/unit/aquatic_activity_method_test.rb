require File.dirname(__FILE__) + '/../test_helper'

class AquaticActivityMethodTest < ActiveSupport::TestCase 
  should_use_table "cdAquaticActivityMethod"
  should_use_primary_key "AquaticMethodCd"
    
  should_have_db_column  "AquaticActivityCd", :type => :integer  
  should_have_db_column  "AquaticMethod", :type => :string, :limit => 30
  
  should_have_instance_methods :aquatic_activity_cd, :aquatic_method
  
  should_alias_attribute :aquatic_method, :name  
  
  should_belong_to :aquatic_activity
end
