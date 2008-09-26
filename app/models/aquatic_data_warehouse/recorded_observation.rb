# == Schema Information
# Schema version: 20080923163956
#
# Table name: tblObservations
#
#  ObservationID             :integer(10)     not null, primary key
#  AquaticActivityID         :integer(10)     
#  OandMCd                   :integer(10)     
#  OandM_Details             :string(150)     
#  OandMValuesCd             :integer(10)     
#  FishPassageObstructionInd :boolean(1)      not null
#  created_at                :datetime        
#  updated_at                :datetime        
#  created_by                :integer(11)     
#  updated_by                :integer(11)     
#

class RecordedObservation < AquaticDataWarehouse::BaseTbl    
  set_table_name  "tblObservations"
  set_primary_key "ObservationID"
  
  belongs_to :aquatic_activity_event, :foreign_key => 'AquaticActivityID'
  belongs_to :observation, :foreign_key => 'OandMCd'
  belongs_to :observable_value, :foreign_key => 'OandMValuesCd'
  
  validates_presence_of :aquatic_activity_event, :observation
    
  named_scope :for_aquatic_activity_event, lambda { |id| { :conditions => ['AquaticActivityID = ?', id], :include => :observation } }
  
  def value_observed
    raise 'Observation needs to be set before value observed can be read' unless observation
    read_attribute(value_observed_column)
  end
  
  def value_observed=(new_value)
    raise 'Observation needs to be set before value observed can be written' unless observation
    write_attribute(value_observed_column, new_value)
  end
  
  def to_label
    "Observation '#{observation.name}'" if observation
  end
  
  private
  def value_observed_column
    observation.has_observable_values? ? 'OandMValuesCd' : 'OandM_Details'
  end
  
  def before_save  
    if observation.has_observable_values?
      write_attribute('OandMValuesCd', value_observed)
    else
      write_attribute('OandM_Details', value_observed)
    end
  end
end
