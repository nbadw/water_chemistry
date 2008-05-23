class CreateUnitOfMeasureCodes < ActiveRecord::Migration
  def self.up
    create_table :unit_of_measure_codes do |t|
      t.string :unit_of_measure
      t.string :unit_of_measure_abbreviation
      t.timestamps
    end
  end

  def self.down
    drop_table :unit_of_measure_codes
  end
end
