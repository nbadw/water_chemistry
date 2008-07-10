require File.dirname(__FILE__) + '/../test_helper'

class ObservationTest < ActiveSupport::TestCase
  should_have_many :observable_values
  should_have_instance_methods :fish_passage_blocked_observation?
  
  should "report if observation has observable values" do
    observation = Observation.spawn
    observation.observable_values << ObservableValue.spawn
    assert observation.has_observable_values?
  end
  
  should "report if observation does not have observable values" do
    observation = Observation.spawn
    observation.observable_values = []
    assert !observation.has_observable_values?
  end
end
