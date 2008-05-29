class CreateCdMeasureInstrument < ActiveRecord::Migration
  def self.up
    create_table "cdMeasureInstrument", :primary_key => "measureinstrumentcd" do |t|
      t.integer "oandmcd"
      t.integer "instrumentcd"      
    end
    add_index "cdMeasureInstrument", "oandmcd"
    add_index "cdMeasureInstrument", "instrumentcd"
  end

  def self.down
    drop_table "cdMeasureInstrument"
  end
end
