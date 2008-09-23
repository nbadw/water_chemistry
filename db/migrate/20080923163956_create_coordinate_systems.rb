class CreateCoordinateSystems < ActiveRecord::Migration
  def self.up
    create_table :coordinate_systems, :primary_key => "epsg" do |t|
      t.string "name",         :limit => 100
      t.string "display_name", :limit => 40
    end
  end

  def self.down
    drop_table :coordinate_systems
  end
end
