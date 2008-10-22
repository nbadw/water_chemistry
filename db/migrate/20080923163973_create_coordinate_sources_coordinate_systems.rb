class CreateCoordinateSourcesCoordinateSystems < ActiveRecord::Migration
  def self.up
    create_table :coordinate_sources_coordinate_systems, :id => false do |t|
      t.references :coordinate_source
      t.references :coordinate_system
    end
  end

  def self.down
    drop_table :coordinate_sources_coordinate_systems
  end
end
