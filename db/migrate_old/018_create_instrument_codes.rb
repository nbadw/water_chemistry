class CreateInstrumentCodes < ActiveRecord::Migration
  def self.up
    create_table :instrument_codes do |t|
      t.string :instrument_name
      t.string :instrument_category
      t.timestamps
    end
  end

  def self.down
    drop_table :instrument_codes
  end
end
