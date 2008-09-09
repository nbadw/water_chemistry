# == Schema Information
# Schema version: 1
#
# Table name: cdOandM
#
#  OandMCd           :integer(10)     not null, primary key
#  OandM_Type        :string(16)      
#  OandM_Category    :string(40)      
#  OandM_Group       :string(50)      
#  OandM_Parameter   :string(50)      
#  OandM_ParameterCd :string(30)      
#  OandM_ValuesInd   :boolean(1)      not null
#  OandM_DetailsInd  :boolean(1)      not null
#  FishPassageInd    :boolean(1)      not null
#  BankInd           :boolean(1)      not null
#

class Observation < OandM
  has_many :observable_values, :foreign_key => 'OandMCd'
  # fish passage blocked observations: 'Man-made dam', 'Habitat enhancement structure', 'Culvert', 'Active beaver dam', 'Inactive beaver dam', 'Large woody debris'
  # observations needing text input:   'Pipe outfall'
      
  def other_observation?
    self.name.to_s.downcase == 'other'
  end
  
  def has_observable_values?
    !self.observable_values.empty?
  end
end
