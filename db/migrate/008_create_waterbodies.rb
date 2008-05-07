class CreateWaterbodies < ActiveRecord::Migration  
  def self.up
    create_table :waterbodies do |t|
      t.string  'name'
      t.string  'abbrev_name'
      t.string  'alt_name' 
      t.string  'drainage_code'
      t.string  'waterbody_type'
      t.integer 'waterbody_complex_id'
      t.boolean 'surveyed'
      t.integer 'flows_into_waterbody_id'
      t.string  'flows_into_waterbody_name'
      t.string  'flows_into_watershed'
      t.timestamp 'date_entered'
      t.timestamp 'date_modified'
      t.timestamps
    end   
  end

  def self.down
    drop_table :waterbodies
  end
end
