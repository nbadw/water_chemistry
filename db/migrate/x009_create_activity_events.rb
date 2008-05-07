class CreateActivityEvents < ActiveRecord::Migration
  def self.up
    create_table :activity_events, :id => false do |t|
      t.integer :activity_id
      t.integer :aquatic_site_id
    end
  end

  def self.down
    drop_table :activity_events
  end
end
