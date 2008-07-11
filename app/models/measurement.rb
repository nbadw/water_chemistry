class Measurement < ActiveRecord::Base  
  class << self    
    def grouping_for_substrate_measurements
      'Substrate Type'
    end
    
    def grouping_for_stream_measurements
      'Stream Type'
    end
  end
  
  has_and_belongs_to_many :instruments, :join_table => 'measurement_instrument'
  has_and_belongs_to_many :units_of_measure, :join_table => 'measurement_unit', :class_name => 'UnitOfMeasure', :association_foreign_key => 'unit_of_measure_id'
    
  def substrate_measurement?
    self.grouping.to_s == Measurement.grouping_for_substrate_measurements
  end
  
  def stream_measurement?
    self.grouping.to_s == Measurement.grouping_for_stream_measurements
  end
end
