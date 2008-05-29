class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.integer :aquatic_activity_id
      t.integer :temporary_aquatic_activity_id
      t.string  :agency_sample_number
      t.decimal :sample_depth_in_meters
      t.string  :water_source_type
      t.integer :sample_collection_method_code
      t.string  :analyzed_by
      t.timestamps
    end
  end

  def self.down
    drop_table :samples
  end
end
