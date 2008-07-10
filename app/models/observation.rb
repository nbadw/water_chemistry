class Observation < ActiveRecord::Base  
  has_many :observable_values 
  # fish passage blocked observations: 'Man-made dam', 'Habitat enhancement structure', 'Culvert', 'Active beaver dam', 'Inactive beaver dam', 'Large woody debris'
  # observations needing text input:   'Pipe outfall'
      
  def other_observation?
    self.name.to_s.downcase == 'other'
  end
  
  def has_observable_values?
    !self.observable_values.empty?
  end
end
