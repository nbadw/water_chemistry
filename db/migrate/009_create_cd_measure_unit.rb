class CreateCdMeasureUnit < ActiveRecord::Migration
  def self.up
    create_table "cdMeasureUnit", :primary_key => "measureunitcd" do |t|
      t.integer "oandmcd"
      t.integer "unitofmeasurecd"
    end
    add_index "cdMeasureUnit", "oandmcd"
    add_index "cdMeasureUnit", "unitofmeasurecd"
  end

  def self.down
    drop_table "cdMeasureUnit"
  end
end
