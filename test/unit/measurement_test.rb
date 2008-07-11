require File.dirname(__FILE__) + '/../test_helper'

class MeasurementTest < ActiveSupport::TestCase
  should_have_and_belong_to_many :instruments, :units_of_measure
  should_have_instance_methods :bank_measurement?
  should_have_class_methods :grouping_for_substrate_measurements, :grouping_for_stream_measurements
  should_have_db_columns :grouping
end
