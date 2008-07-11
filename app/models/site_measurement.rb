class SiteMeasurement < ActiveRecord::Base
  belongs_to :aquatic_site
  belongs_to :aquatic_activity_event
  belongs_to :measurement
  belongs_to :instrument
  belongs_to :unit_of_measure
  
  validates_presence_of :aquatic_site, :aquatic_activity_event, :measurement, :instrument, :unit_of_measure, :value_measured
  validates_inclusion_of :bank, :in => %w(Left Right), :allow_nil => true
  validates_numericality_of :value_measured
  
  class << self
    def calculate_substrate_accounted_for(aquatic_activity_event_id)
      sum_values_observed_in_measurement_group_for_aquatic_activity_event(aquatic_activity_event_id, Measurement.grouping_for_substrate_measurements)
    end
    
    def calculate_stream_accounted_for(aquatic_activity_event_id)
      sum_values_observed_in_measurement_group_for_aquatic_activity_event(aquatic_activity_event_id, Measurement.grouping_for_stream_measurements)
    end
    
    def sum_values_observed_in_measurement_group_for_aquatic_activity_event(aquatic_activity_event_id, group)
      conditions = [
        "#{self.table_name}.aquatic_activity_event_id = ? AND #{Measurement.table_name}.grouping = ?", 
        aquatic_activity_event_id,
        group
      ]
      self.find(:all, :include => :measurement, :conditions => conditions).inject(0) { |sum, site_measurement| sum + site_measurement.value_measured.to_f }
    end
  end
end
