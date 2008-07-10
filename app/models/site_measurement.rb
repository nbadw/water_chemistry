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
    def substrate_accounted_for(aquatic_activity_event_id)
      site_measurements = self.find_all_by_aquatic_activity_event_id(aquatic_activity_event_id, :include => :measurement)
      site_measurements.inject(0) do |sum, site_measurement|
        group = site_measurement.measurement.grouping.to_s
        sum += site_measurement.value_measured.to_f if group == 'Substrate Type'
        sum
      end
    end
  end
end
