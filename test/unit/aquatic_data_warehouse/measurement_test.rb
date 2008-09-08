require File.dirname(__FILE__) + '/../../test_helper'
require File.dirname(__FILE__) + '/oand_m_test'

class MeasurementTest < OandMTest
  should_have_and_belong_to_many :instruments, :units_of_measure
  should_have_class_methods :grouping_for_substrate_measurements, :grouping_for_stream_measurements
    
  should_eventually "have bank measurement column"
  should_have_instance_methods :grouping
end
