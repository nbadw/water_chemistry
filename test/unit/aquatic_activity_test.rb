require File.dirname(__FILE__) + '/../test_helper'

class AquaticActivityTest < ActiveSupport::TestCase
  should_belong_to :aquatic_site
  should_belong_to :aquatic_activity_code
end
