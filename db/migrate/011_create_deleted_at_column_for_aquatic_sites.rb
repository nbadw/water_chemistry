class CreateDeletedAtColumnForAquaticSites < ActiveRecord::Migration
  def self.up
    add_column :aquatic_sites, "deleted_at", :timestamp
  end

  def self.down
    remove_column :aquatic_sites, "deleted_at"
  end
end
