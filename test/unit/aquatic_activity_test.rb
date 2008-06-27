require File.dirname(__FILE__) + '/../test_helper'

class AquaticActivityTest < ActiveSupport::TestCase
  should_have_many :aquatic_activity_events
end
