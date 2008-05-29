class CreateCdOAndMValues < ActiveRecord::Migration
  def self.up
    create_table "cdOandMValues", :primary_key => "oandmvaluescd" do |t|
      t.integer "oandmcd"
      t.string  "value",         :limit => 40
    end
    add_index "cdOandMValues", "oandmcd"
  end

  def self.down
    drop_table "cdOandMValues"
  end
end
