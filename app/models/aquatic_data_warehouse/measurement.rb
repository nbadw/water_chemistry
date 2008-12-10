# == Schema Information
# Schema version: 20081127150314
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
#  created_at        :datetime        
#  updated_at        :datetime        
#  created_by        :integer(11)     
#  updated_by        :integer(11)     
#

class Measurement < OandM
  class << self    
    def substrate_measurements_group
      'Substrate Type'
    end
    
    def stream_measurements_group
      'Stream Type'
    end
  end
  
  has_and_belongs_to_many :instruments, :join_table => 'cdmeasureinstrument', :foreign_key => 'OandMCd', :association_foreign_key => 'InstrumentCd'
  has_and_belongs_to_many :units_of_measure, :join_table => 'cdmeasureunit', :class_name => 'UnitOfMeasure', :foreign_key => 'OandMCd', :association_foreign_key => 'UnitofMeasureCd'
  
  def substrate_measurement?
    group.to_s == Measurement.substrate_measurements_group
  end
  
  def stream_measurement?
    group.to_s == Measurement.stream_measurements_group
  end
  
  def bank_measurement?
    bank_ind
  end
    
  def self.finder_needs_type_condition?
    true
  end
  
  named_scope :chemicals, :conditions => { 'OandM_Category' => 'Water', 'OandM_Group' => 'Chemical' }
  named_scope :water,  :conditions => { 'OandM_Category' => 'Water', 'OandM_Group' => 'Physical' }
  named_scope :site,   :conditions => { 'OandM_Category' => ['Site', 'Aquatic Characteristic'] }
end
