class CreateWaterMeasurements < ActiveRecord::Migration
  def self.up
    create_table :water_measurements do |t|
      t.integer   :aquatic_activity_id
      t.integer   :temporary_aquatic_activity_id
      t.integer   :temperature_data_id
      t.integer   :temperature_logger_id
      t.integer   :habitat_unit_id
      t.integer   :sample_id
      t.string    :water_source_type
      t.decimal   :water_depth_in_meters
      t.timestamp :time_of_day
      t.integer   :observation_and_measurement_code
      t.integer   :instrument_code
      t.integer   :measurement
      t.integer   :unit_of_measure_code
      t.boolean   :detection_limit
      t.string    :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :water_measurements
  end
end
