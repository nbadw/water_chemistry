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

class Measurement < OandM
  class << self    
    def grouping_for_substrate_measurements
      'Substrate Type'
    end
    
    def grouping_for_stream_measurements
      'Stream Type'
    end
  end
  
  has_and_belongs_to_many :instruments, :join_table => 'cdmeasureinstrument', :foreign_key => 'OandMCd', :association_foreign_key => 'InstrumentCd'
  has_and_belongs_to_many :units_of_measure, :join_table => 'cdmeasureunit', :class_name => 'UnitOfMeasure', :foreign_key => 'OandMCd', :association_foreign_key => 'UnitofMeasureCd'
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  
  def substrate_measurement?
    self.grouping.to_s == Measurement.grouping_for_substrate_measurements
  end
  
  def stream_measurement?
    self.grouping.to_s == Measurement.grouping_for_stream_measurements
  end
  
  named_scope :chemical_parameters, :conditions => { 'OandM_Category' => 'Water', 'OandM_Group' => 'Chemical' }
  named_scope :water_measurements,  :conditions => { 'OandM_Category' => 'Water', 'OandM_Group' => 'Physical' }
  named_scope :site_measurements,   :conditions => { 'OandM_Category' => ['Site', 'Aquatic Characteristic'] }
end
