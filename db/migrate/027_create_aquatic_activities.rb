class CreateAquaticActivities < ActiveRecord::Migration
  def self.up
    create_table :aquatic_activities do |t|
      t.integer   :temporary_id
      t.string    :project
      t.string    :permit_number
      t.integer   :aquatic_program_id
      t.integer   :aquatic_activity_code
      t.integer   :aquatic_method_code
      t.integer   :old_aquatic_site_id
      t.integer   :aquatic_site_id
      t.timestamp :start_date
      t.timestamp :end_date
      t.string    :agency_code
      t.string    :agency2_code
      t.string    :agency2_contact
      t.string    :leader
      t.string    :crew
      t.string    :weather_conditions
      t.decimal   :water_temperature_in_celsius
      t.decimal   :air_temperature_in_celsius
      t.string    :water_level
      t.decimal   :water_level_in_cm
      t.decimal   :morning_water_level_in_cm
      t.decimal   :evening_water_level_in_cm
      t.string    :siltation
      t.boolean   :primary_activity
      t.string    :comments
      t.timestamp :entered_at
      t.timestamp :transferred_at
      t.timestamp :incorporated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :aquatic_activities
  end
end
