class CreateTblObservations < ActiveRecord::Migration
  def self.up
    create_table "tblObservations", :primary_key => "observationid" do |t|
      t.integer "aquaticactivityid"
      t.integer "oandmcd"
      t.string  "oandm_other",               :limit => 50
      t.string  "oandmvaluescd"
      t.integer "pipesize_cm"
      t.boolean "fishpassageobstructionind"
    end
    add_index "tblObservations", "aquaticactivityid"
  end

  def self.down
    drop_table "tblObservations"
  end
end
