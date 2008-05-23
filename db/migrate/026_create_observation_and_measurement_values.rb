class CreateObservationAndMeasurementValues < ActiveRecord::Migration
  def self.up
    create_table :observation_and_measurement_values do |t|
      t.integer :observation_and_measurement_code
      t.string  :value
      t.timestamps
    end
  end

  def self.down
    drop_table :observation_and_measurement_values
  end
end
