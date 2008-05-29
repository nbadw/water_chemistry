class CreateCdUnitOfMeasure < ActiveRecord::Migration
  def self.up
    create_table "cdUnitofMeasure", :primary_key => "unitofmeasurecd" do |t|
      t.string  "unitofmeasure",    :limit => 100
      t.string  "unitofmeasureabv", :limit => 20
    end
  end

  def self.down
    drop_table "cdUnitofMeasure"
  end
end
