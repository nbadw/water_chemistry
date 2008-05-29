class CreateCdAquaticActivityMethod < ActiveRecord::Migration
  def self.up
    create_table "cdAquaticActivityMethod", :primary_key => "aquaticmethodcd" do |t|
      t.integer "aquaticactivitycd"
      t.string  "aquaticmethod",     :limit => 60
    end
    add_index "cdAquaticActivityMethod", "aquaticactivitycd"
  end

  def self.down
    drop_table "cdAquaticActivityMethod"
  end
end
