# == Schema Information
# Schema version: 20081127150314
#
# Table name: tblSiteMeasurement
#
#  SiteMeasurementID :integer(10)     not null, primary key
#  AquaticActivityID :integer(10)     
#  OandMCd           :integer(10)     
#  OandM_Other       :string(20)      
#  Bank              :string(10)      
#  InstrumentCd      :integer(10)     
#  Measurement       :float(15)       
#  UnitofMeasureCd   :integer(10)     
#  created_at        :datetime        
#  updated_at        :datetime        
#  created_by        :integer(11)     
#  updated_by        :integer(11)     
#

class SiteMeasurement < AquaticDataWarehouse::BaseTbl
  LEFT_BANK  = "Left".freeze
  RIGHT_BANK = "Right".freeze

  set_primary_key 'SiteMeasurementID'
  
  belongs_to :o_and_m, :class_name => 'Measurement', :foreign_key => 'OandMCd'
  belongs_to :instrument, :foreign_key => 'InstrumentCd'
  belongs_to :unit_of_measure, :foreign_key => 'UnitofMeasureCd'
  belongs_to :aquatic_activity_event, :foreign_key => 'AquaticActivityID'

  validates_presence_of :aquatic_activity_event, :o_and_m, :instrument, :unit_of_measure, :measurement
  
  named_scope :for_aquatic_activity_event, lambda { |id| { :conditions => ['AquaticActivityID = ?', id], :include => :o_and_m } }
    
  validates_inclusion_of :bank, :in => [LEFT_BANK, RIGHT_BANK], :if => Proc.new { |site_measurement| site_measurement.o_and_m.bank_measurement? if site_measurement.o_and_m }
  validates_numericality_of :measurement

  def to_label
    o_and_m.name if o_and_m
  end
  
  class << self   
    def recorded_measurements(aquatic_activity_event_id)
      site_measurements = self.for_aquatic_activity_event(aquatic_activity_event_id)
      remove_bank_measurements_with_no_complement(site_measurements)
      recorded = site_measurements.collect do |site_meas|
        measurement = Measurement.new(site_meas.o_and_m.attributes)
        measurement.id = site_meas.o_and_m.oand_m_cd
        measurement
      end
    end
  
    def calculate_bank_accounted_for(aquatic_activity_event_id)
      conditions = [
        "#{self.table_name}.AquaticActivityID = ? AND #{Measurement.table_name}.BankInd = ?", 
        aquatic_activity_event_id, true        
      ]
      collected_sums = self.sum(:measurement, :select => :measurement, :include => :o_and_m, :conditions => conditions, :group => "#{Measurement.table_name}.OandM_Parameter")
      collected_sums.each { |name, val| collected_sums[name] = val.to_f }
    end
    
    def calculate_substrate_accounted_for(aquatic_activity_event_id)
      sum_values_observed(aquatic_activity_event_id, Measurement.substrate_measurements_group)
    end
    
    def calculate_stream_accounted_for(aquatic_activity_event_id)
      sum_values_observed(aquatic_activity_event_id, Measurement.stream_measurements_group)
    end
    
    def sum_values_observed(aquatic_activity_event_id, group)
      conditions = ["#{self.table_name}.AquaticActivityID = ? AND #{Measurement.table_name}.OandM_Group = ?", aquatic_activity_event_id, group]
      self.sum(:measurement, :select => :measurement, :include => :o_and_m, :conditions => conditions).to_f
    end
            
    def remove_bank_measurements_with_no_complement(site_measurements)
      recorded_measurements = site_measurements.collect{ |site_measurement| site_measurement.o_and_m }
      recorded_bank_measurements = left_bank_measurements(site_measurements) & right_bank_measurements(site_measurements)
      recorded_measurements.collect do |measurement|
        if measurement.bank_measurement?
          measurement = recorded_bank_measurements.include?(measurement) ? measurement : nil
        end
        measurement
      end.compact
    end
  
    def left_bank_measurements(site_measurements)
      collect_bank_measurements('Left', site_measurements)
    end
  
    def right_bank_measurements(site_measurements)
      collect_bank_measurements('Right', site_measurements)
    end
  
    def collect_bank_measurements(side, site_measurements)
      site_measurements.collect do |site_measurement|
        measurement = site_measurement.o_and_m
        measurement if measurement.bank_measurement? && site_measurement.bank.to_s == side
      end.compact
    end
  end
end
