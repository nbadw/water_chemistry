# == Schema Information
# Schema version: 1
#
# Table name: observations
#
#  id                               :integer(11)     not null, primary key
#  name                             :string(255)     
#  grouping                         :string(255)     
#  category                         :string(255)     
#  imported_at                      :datetime        
#  exported_at                      :datetime        
#  created_at                       :datetime        
#  updated_at                       :datetime        
#  fish_passage_blocked_observation :boolean(1)      
#

class Observation < AquaticDataWarehouse::Base  
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
