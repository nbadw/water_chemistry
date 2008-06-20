require File.dirname(__FILE__) + '/../test_helper'

class TblSiteMeasurementTest < ActiveSupport::TestCase
  should_belong_to :aquatic_activity, :measurement_code
  should_require_attributes :aquatic_activity, :measurement_code, :measurement
end
