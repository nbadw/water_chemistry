# == Schema Information
# Schema version: 20081008163622
#
# Table name: tblWaterMeasurement
#
#  WaterMeasurementID    :integer(10)     not null, primary key
#  AquaticActivityID     :integer(10)     
#  TempAquaticActivityID :integer(10)     
#  TempDataID            :integer(10)     
#  TemperatureLoggerID   :integer(10)     
#  HabitatUnitID         :integer(10)     
#  SampleID              :integer(10)     
#  WaterSourceCd         :string(50)      
#  WaterDepth_m          :float(7)        
#  TimeofDay             :string(5)       
#  OandMCd               :integer(10)     
#  InstrumentCd          :integer(10)     
#  Measurement           :float(7)        
#  UnitofMeasureCd       :integer(10)     
#  QualifierCd           :string(20)      
#  Comment               :string(255)     
#  created_at            :datetime        
#  updated_at            :datetime        
#  created_by            :integer(11)     
#  updated_by            :integer(11)     
#

class WaterMeasurement < AquaticDataWarehouse::BaseTbl
  set_primary_key 'WaterMeasurementID'
  
  belongs_to :o_and_m, :class_name => 'Measurement', :foreign_key => 'OandMCd'
  belongs_to :instrument, :foreign_key => 'InstrumentCd'
  belongs_to :unit_of_measure, :foreign_key => 'UnitofMeasureCd'
  belongs_to :sample, :foreign_key => 'SampleID'
  belongs_to :qualifier, :foreign_key => 'QualifierCd'
  
  validates_presence_of :o_and_m, :measurement
  validates_numericality_of :measurement
  
  named_scope :for_sample, lambda { |id| { :conditions => ['SampleID = ?', id], :include => [:o_and_m, :qualifier] } }
  
  def self.recorded_chemicals(sample_id)
    self.for_sample(sample_id).collect do |water_meas|
      chemical = Measurement.new(water_meas.chemical.attributes)
      chemical.id = water_meas.chemical.oand_m_cd
      chemical
    end
  end
  
  def chemical
    o_and_m
  end
end
