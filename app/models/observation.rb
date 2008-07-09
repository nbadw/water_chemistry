class Observation < ActiveRecord::Base
  @@fish_passage_blocked_observations = []
  @@text_input_observations = []
  cattr_accessor :fish_passage_blocked_observations, :text_input_observations
    
  class << self       
    def define_fish_passage_blocked_observation(*names)
      names.each { |name| self.fish_passage_blocked_observations << name }
    end
    
    def define_observation_needing_text_input(*names)
      names.each { |name| self.text_input_observations << name }
    end
  end
  
  has_many :observable_values
  define_fish_passage_blocked_observation 'Man-made dam', 'Habitat enhancement structure'  
  define_observation_needing_text_input 'Pipe outfall'
    
  def fish_passage_blocked_observation?    
    Observation.fish_passage_blocked_observations.any? { |obs_name| self.name.to_s.casecmp(obs_name) == 0 }
  end
  
  def needs_input?
    needs_text_input? || has_observable_values?
  end
  
  def needs_text_input?
    Observation.text_input_observations.any? { |obs_name| self.name.to_s.casecmp(obs_name) == 0 }
  end
  
  def has_observable_values?
    !self.observable_values.empty?
  end
end
