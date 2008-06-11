class CreateTblEnvironmentalObservation < ActiveRecord::Migration
  def self.up
    create_table "tblEnvironmentalObservations", :primary_key => "envobservationid" do |t|
      t.integer "aquaticactivityid"
      t.string  "observationgroup",          :limit => 100
      t.string  "observation",               :limit => 100
      t.string  "observationsupp",           :limit => 100
      t.integer "pipesize_cm"
      t.boolean "fishpassageobstructionind"
    end
    add_index "tblEnvironmentalObservations", "aquaticactivityid"
  end

  def self.down
    drop_table "tblEnvironmentalObservations"
  end
end
