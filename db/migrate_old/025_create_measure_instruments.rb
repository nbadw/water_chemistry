class CreateMeasureInstruments < ActiveRecord::Migration
  def self.up
    create_table :measure_instruments do |t|
      t.integer :observation_and_measurement_code
      t.integer :instrument_code
      t.timestamps
    end
  end

  def self.down
    drop_table :measure_instruments
  end
end
