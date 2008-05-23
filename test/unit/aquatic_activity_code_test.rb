require File.dirname(__FILE__) + '/../test_helper'

class AquaticActivityCodeTest < ActiveSupport::TestCase
  should_have_many :aquatic_activities 
end
