require File.dirname(__FILE__) + '/../test_helper'

class AquaticActivityMethodTest < ActiveSupport::TestCase   
  should_define_attributes :aquatic_activity_id, :method
  should_alias_attribute :method, :name
  should_define_timestamps
end
