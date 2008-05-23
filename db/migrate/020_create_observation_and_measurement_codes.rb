class CreateObservationAndMeasurementCodes < ActiveRecord::Migration
  def self.up
    create_table :observation_and_measurement_codes do |t|      
      t.string  :category
      t.string  :group
      t.string  :parameter
      t.string  :parameter_code
      t.boolean :values
      t.string  :o_and_m_type
      t.timestamps
    end
  end

  def self.down
    drop_table :observation_and_measurement_codes
  end
end
