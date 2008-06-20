class CreateTblSiteMeasurements < ActiveRecord::Migration
  def self.up
    create_table "tblSiteMeasurement", :primary_key => 'sitemeasurementid' do |t|
      t.integer :aquaticactivityid
      t.integer :oandmcd
      t.string  :oandm_other
      t.string  :bank
      t.integer :instrumentcd
      t.decimal :measurement
      t.integer :unitofmeasurecd
    end
    add_index "tblSiteMeasurement", "aquaticactivityid"
  end

  def self.down
    drop_table "tblSiteMeasurement"
  end
end
