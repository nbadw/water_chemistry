require File.dirname(__FILE__) + '/../test_helper'

class ObservationTest < ActiveSupport::TestCase
  should_have_many :observable_values
  
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
  
  should "report if observation is a 'fish passage blocked' observation" do
    Observation.fish_passage_blocked_observations.clear
    Observation.define_fish_passage_blocked_observation 'Man-made Dam'
    assert Observation.spawn(:name => 'Man-made Dam').fish_passage_blocked_observation?    
  end
  
  should "report if observation is not a 'fish passage blocked' observation" do
    Observation.fish_passage_blocked_observations.clear
    assert !Observation.spawn(:name => 'Erosion').fish_passage_blocked_observation?    
  end
  
  should "report if observation needs text input" do
    Observation.text_input_observations.clear
    Observation.define_observation_needing_text_input "Pipe Outfall"
    assert Observation.spawn(:name => 'Pipe Outfall').needs_text_input?    
  end
  
  should "report if observation does not need text input" do
    Observation.text_input_observations.clear
    assert !Observation.spawn(:name => 'No Text Input').needs_text_input?
  end
end
