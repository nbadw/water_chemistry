require File.dirname(__FILE__) + '/../test_helper'

class TblWaterMeasurementTest < ActiveSupport::TestCase
  should_belong_to :aquatic_activity, :sample
end
