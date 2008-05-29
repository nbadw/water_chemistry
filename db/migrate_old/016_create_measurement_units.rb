class CreateMeasurementUnits < ActiveRecord::Migration
  def self.up
    create_table :measurement_units do |t|
      t.string :name
      t.string :symbol
      t.timestamps
    end
  end

  def self.down
    drop_table :measurement_units
  end
end
