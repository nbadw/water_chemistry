class CreateEnvironmentalObservations < ActiveRecord::Migration
  def self.up
    create_table :environmental_observations do |t|
      t.integer :aguatic_activity_id
      t.string  :observation_group
      t.string  :observation
      t.string  :observation_supp
      t.decimal :pipe_size_in_cm
      t.boolean :fish_passage_obstruction
      t.timestamps
    end
  end

  def self.down
    drop_table :environmental_observations
  end
end
