require File.dirname(__FILE__) + '/../test_helper'

class MeasurementUnitTest < ActiveSupport::TestCase
  should_require_attributes :name, :symbol
end
 