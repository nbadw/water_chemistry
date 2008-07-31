require File.dirname(__FILE__) + '/../test_helper'

class AquaticActivityMethodTest < ActiveSupport::TestCase 
  should_use_table :cdaquaticactivitymethod
  should_use_primary_key :aquaticmethodcd
  
  should_have_db_column  :aquaticactivitycd, :type => :integer
  should_alias_attribute :aquaticactivitycd, :aquatic_activity_id
  
  should_have_db_column  :aquaticmethod, :type => :string, :limit => 30
  should_alias_attribute :aquaticmethod, :method
  should_alias_attribute :aquaticmethod, :name
  
  should_define_timestamps
end
