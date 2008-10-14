class CreateGmapLocations < ActiveRecord::Migration
  def self.up
    create_table :gmap_locations do |t|
      t.references :locatable, :polymorphic => true
      t.decimal    :latitude,  :precision => 15, :scale => 10
      t.decimal    :longitude, :precision => 15, :scale => 10
    end
  end

  def self.down
    drop_table :gmap_locations
  end
end
