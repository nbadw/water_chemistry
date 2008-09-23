class CreateCoordinateSources < ActiveRecord::Migration
  def self.up
    create_table :coordinate_sources do |t|
      t.string  "name", :limit => 30
    end
  end

  def self.down
    drop_table :coordinate_sources
  end
end
