require File.dirname(__FILE__) + '/../test_helper'

class MeasurementTest < ActiveSupport::TestCase
  should_have_and_belong_to_many :instruments, :units_of_measure
  should_have_instance_methods :bank_measurement?
end
