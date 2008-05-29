class CreateAquaticSites < ActiveRecord::Migration
  def self.up
    create_table :aquatic_sites do |t|
      t.integer   :old_aquatic_site_id
      t.integer   :river_system_id
      t.integer   :waterbody_id
      t.string    :name
      t.string    :description
      t.string    :habitat_desc
      t.integer   :reach_no
      t.string    :start_desc
      t.string    :end_desc
      t.float     :start_route_meas
      t.float     :end_route_meas
      t.string    :site_type
      t.boolean   :specific_site
      t.boolean   :georeferenced
      t.timestamp :entered_at
      t.timestamp :incorporated_at
      t.string    :coordinate_source
      t.string    :coordinate_system
      t.string    :coordinate_units
      t.string    :x_coord
      t.string    :y_coord
      t.string    :comments
      t.timestamps
    end   
  end

  def self.down
    drop_table :aquatic_sites
  end  
end
