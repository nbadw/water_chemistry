class SiteMeasurement < ActiveRecord::Base
  LEFT_BANK  = "Left"
  RIGHT_BANK = "Right"
  
  belongs_to :aquatic_site
  belongs_to :aquatic_activity_event
  belongs_to :measurement
  belongs_to :instrument
  belongs_to :unit_of_measure
  
  validates_presence_of :aquatic_site, :aquatic_activity_event, :measurement, :instrument, :unit_of_measure, :value_measured
  validates_inclusion_of :bank, :in => [LEFT_BANK, RIGHT_BANK], :if => Proc.new { |site_measurement| site_measurement.measurement.bank_measurement? if site_measurement.measurement }
  validates_numericality_of :value_measured
  
  class << self    
    def calculate_bank_accounted_for(aquatic_activity_event_id)
      conditions = ["#{self.table_name}.aquatic_activity_event_id = ? && #{Measurement.table_name}.bank_measurement = ?", aquatic_activity_event_id, true]
      collected_sums = self.sum(:value_measured, :select => :value_measured, :include => :measurement, :conditions => conditions, :group => "#{Measurement.table_name}.name")
      collected_sums.each { |name, val| collected_sums[name] = val.to_f }
    end
    
    def calculate_substrate_accounted_for(aquatic_activity_event_id)
      sum_values_observed(aquatic_activity_event_id, Measurement.grouping_for_substrate_measurements)
    end
    
    def calculate_stream_accounted_for(aquatic_activity_event_id)
      sum_values_observed(aquatic_activity_event_id, Measurement.grouping_for_stream_measurements)
    end
    
    def sum_values_observed(aquatic_activity_event_id, group)
      conditions = ["#{self.table_name}.aquatic_activity_event_id = ? AND #{Measurement.table_name}.grouping = ?", aquatic_activity_event_id, group]
      self.sum(:value_measured, :select => :value_measured, :include => :measurement, :conditions => conditions).to_f
    end
    
    def find_recorded_measurements(aquatic_activity_event_id)
      site_measurements = SiteMeasurement.find_all_by_aquatic_activity_event_id(aquatic_activity_event_id, :include => :measurement)          
      recorded_measurements = remove_bank_measurements_with_no_complement(site_measurements)
      recorded_measurements
    end   
        
    def remove_bank_measurements_with_no_complement(site_measurements)
      recorded_measurements = site_measurements.collect{ |site_measurement| site_measurement.measurement }
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
        measurement = site_measurement.measurement
        measurement if measurement.bank_measurement? && site_measurement.bank.to_s == side
      end.compact
    end
  end
end
