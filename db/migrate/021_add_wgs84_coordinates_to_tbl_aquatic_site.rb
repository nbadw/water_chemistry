class AddWgs84CoordinatesToTblAquaticSite < ActiveRecord::Migration
  def self.up
    add_column "tblAquaticSite", 'wgs84_lat', :decimal, :precision => 15, :scale => 10
    add_column "tblAquaticSite", 'wgs84_lon', :decimal, :precision => 15, :scale => 10
  end

  def self.down
    remove_column :aquatic_sites, 'wgs84_lat'
    remove_column :aquatic_sites, 'wgs84_lon'
  end
end
