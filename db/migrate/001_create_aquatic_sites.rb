class CreateAquaticSites < ActiveRecord::Migration
  def self.up
    create_table :aquatic_sites do |t|
      t.string  :name
      t.string  :description
      t.integer :waterbody_id
      t.string  :drainage_code
      t.point   :geom, :null => false, :srid => 4326, :with_z => false
      t.timestamps
    end    
    add_index :aquatic_sites, :geom, :spatial => true
  end

  def self.down
    remove_index :aquatic_sites, :geom
    drop_table :aquatic_sites
  end
end
