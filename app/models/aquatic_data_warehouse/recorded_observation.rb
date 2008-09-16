class RecordedObservation < AquaticDataWarehouse::BaseTbl  
  set_table_name  "tblObservations"
  set_primary_key "ObservationID"
  
  belongs_to :aquatic_activity_event, :foreign_key => 'AquaticActivityID'
  belongs_to :observation, :foreign_key => 'OandMCd'
  belongs_to :observable_value, :foreign_key => 'OandMValuesCd'
  
  validates_presence_of :aquatic_activity_event, :observation
  
  def value_observed
    oand_m_details
  end
  
  named_scope :for_aquatic_activity_event, lambda { |id| { :conditions => ['AquaticActivityID = ?', id], :include => :observation } }
end
