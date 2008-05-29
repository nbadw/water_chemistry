class CreateCdInstrument < ActiveRecord::Migration
  def self.up
    create_table "cdInstrument", :primary_key => "instrumentcd" do |t|
      t.string  "instrument",          :limit => 100
      t.string  "instrument_category", :limit => 100
    end
  end

  def self.down
    drop_table "cdInstrument"
  end
end
