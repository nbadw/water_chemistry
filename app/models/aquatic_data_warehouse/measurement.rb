# == Schema Information
# Schema version: 1
#
# Table name: measurements
#
#  id               :integer(11)     not null, primary key
#  name             :string(255)     
#  grouping         :string(255)     
#  category         :string(255)     
#  imported_at      :datetime        
#  exported_at      :datetime        
#  created_at       :datetime        
#  updated_at       :datetime        
#  bank_measurement :boolean(1)      
#

class Measurement < OandM
  class << self    
    def grouping_for_substrate_measurements
      'Substrate Type'
    end
    
    def grouping_for_stream_measurements
      'Stream Type'
    end
  end
  
  has_and_belongs_to_many :instruments, :join_table => 'cdMeasureInstrument', :association_foreign_key => 'InstrumentCd'
  has_and_belongs_to_many :units_of_measure, :join_table => 'cdMeasureUnit', :class_name => 'UnitOfMeasure', :association_foreign_key => 'UnitofMeasureCd'
  
  validates_presence_of   :name
  validates_uniqueness_of :name
    
  def substrate_measurement?
    self.grouping.to_s == Measurement.grouping_for_substrate_measurements
  end
  
  def stream_measurement?
    self.grouping.to_s == Measurement.grouping_for_stream_measurements
  end
end
