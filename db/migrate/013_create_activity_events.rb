class CreateActivityEvents < ActiveRecord::Migration
  def self.up
    create_table :activity_events do |t|
      t.string    'project'
      t.string    'permit_number'
      t.integer   'aquatic_program_id'
      t.integer   'aquatic_activity_code'
      t.integer   'aquatic_method_code'
      t.integer   'old_aquatic_site_id'
      t.integer   'aquatic_site_id'
      t.timestamp 'starts_at'
      t.timestamp 'ends_at'
      t.string    'agency_code'
      t.string    'agency2_code'
      t.string    'agency2_contact'
      t.string    'aquatic_activity_leader'
      t.string    'crew'
      t.string    'weather_conditions'
      t.decimal   'water_temp_in_celsius'
      t.decimal   'air_temp_in_celsius'
      t.string    'water_level'
      t.string    'water_level_in_cm'
      t.string    'morning_water_level_in_cm'
      t.string    'evening_water_level_in_cm'
      t.string    'siltation'
      t.boolean   'primary_activity'
      t.string    'comments'
      t.timestamp 'entered_at'
      t.timestamp 'incorporated_at'
      t.timestamp 'transferred_at'
      t.timestamps
    end
    
    add_index :activity_events, 'aquatic_program_id'
    add_index :activity_events, 'aquatic_activity_code'
    add_index :activity_events, 'aquatic_method_code'
    add_index :activity_events, 'aquatic_site_id'
    add_index :activity_events, 'agency_code'
    add_index :activity_events, 'agency2_code'
  end

  def self.down
    drop_table :activity_events
  end
end
