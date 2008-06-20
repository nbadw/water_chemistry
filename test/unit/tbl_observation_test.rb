require File.dirname(__FILE__) + '/../test_helper'

class TblObservationTest < ActiveSupport::TestCase
  should_belong_to :aquatic_activity, :observation_code
end
