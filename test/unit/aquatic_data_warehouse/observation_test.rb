require File.dirname(__FILE__) + '/../../test_helper'
require File.dirname(__FILE__) + '/oand_m_test'
require 'mocha'

class ObservationTest < OandMTest    
  should_have_many :observable_values
  should_eventually '_have_instance_methods :fish_passage_blocked_observation?'
  
  should_eventually "report if observation has observable values" do
    observation = Observation.new
    Observation.expects(:observable_values).returns([ObservableValue.new])
    assert observation.has_observable_values?
  end
  
  should_eventually "report if observation does not have observable values" do
    observation = Observation.new    
    ObservableValue.expects(:find).returns([])
    assert !observation.has_observable_values?
  end
  
  should "be a concrete subclass that needs an STI type condition" do
    assert Observation.finder_needs_type_condition?
  end
end
