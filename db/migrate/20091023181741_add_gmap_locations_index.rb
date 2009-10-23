class AddGmapLocationsIndex < ActiveRecord::Migration
  def self.up
     add_index(:gmap_locations, [:locatable_id, :locatable_type], :name => 'locatable_index')
  end

  def self.down
    remove_index(:gmap_locations, :name => 'locatable_index')
  end
end
