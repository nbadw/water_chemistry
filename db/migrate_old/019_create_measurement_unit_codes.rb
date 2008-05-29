class CreateMeasurementUnitCodes < ActiveRecord::Migration
  def self.up
    create_table :measurement_unit_codes do |t|
      t.integer :observation_and_measurement_code
      t.integer :unit_of_measure_code
      t.timestamps
    end
  end

  def self.down
    drop_table :measurement_unit_codes
  end
end
