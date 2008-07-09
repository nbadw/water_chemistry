class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string    :login                   
      t.string    :email                  
      t.string    :crypted_password,             :limit => 40
      t.string    :salt,                         :limit => 40
      t.string    :remember_token         
      t.timestamp :remember_token_expires_at  
      t.string    :activation_code,              :limit => 40
      t.timestamp :activated_at         
      t.string    :password_reset_code,          :limit => 40
      t.boolean   :enabled,                      :default => true   
      t.integer   :agency_id
      t.timestamps
    end
    
    add_index :users, [:agency_id]
    
    create_table :roles do |t|
      t.string :rolename
      t.timestamps
    end
    
    create_table :permissions do |t|
      t.integer :role_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    
    add_index :permissions, [:role_id]
    add_index :permissions, [:user_id]
    
    create_table :agencies do |t|
      t.string    :code,       :limit => 10,  :null => false, :unique => true
      t.string    :name,       :limit => 120
      t.string    :type,       :limit => 8
      t.boolean   :data_rules, :default => false
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end

    create_table :aquatic_activities do |t|
      t.string    :name,        :limit => 100, :unique => true
      t.string    :category,    :limit => 60
      t.string    :duration,    :limit => 40
      t.timestamp :imported_at  
      t.timestamp :exported_at  
      t.timestamps
    end

    create_table :aquatic_activity_methods do |t|
      t.integer   :aquatic_activity_id
      t.string    :method,              :limit => 60
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end

    add_index :aquatic_activity_methods, [:aquatic_activity_id]
    
    create_table :observations do |t|      
      t.string    :name
      t.string    :grouping
      t.string    :category
      t.timestamp :imported_at  
      t.timestamp :exported_at
      t.timestamps
    end
    
    create_table :observable_values do |t|
      t.references :observation
      t.string     :value
      t.timestamp  :imported_at  
      t.timestamp  :exported_at
      t.timestamps
    end
    
    create_table :site_observations do |t|
      t.references :aquatic_site
      t.references :aquatic_activity_event
      t.references :observation
      t.string     :value_observed
      t.timestamp  :imported_at  
      t.timestamp  :exported_at
      t.timestamps
    end
    
    create_table :measurements do |t|
      t.string :name
      t.string :grouping
      t.string :category
      t.timestamp :imported_at  
      t.timestamp :exported_at
      t.timestamps
    end
        
    create_table :site_measurements do |t|
      t.references :aquatic_site
      t.references :aquatic_activity_event
      t.references :measurement
      t.references :instrument
      t.references :unit_of_measure
      t.string     :value_measured
      t.timestamp  :imported_at  
      t.timestamp  :exported_at
      t.timestamps
    end

    create_table :instruments do |t|
      t.string    :name,        :limit => 100
      t.string    :category,    :limit => 100
      t.timestamp :imported_at  
      t.timestamp :exported_at
      t.timestamps
    end
    
    create_table :units_of_measure do |t|
      t.string    :name,        :limit => 100
      t.string    :unit,        :limit => 20
      t.timestamp :imported_at  
      t.timestamp :exported_at
      t.timestamps
    end
    
    create_table :measurement_instrument do |t|
      t.references :measurement
      t.references :instrument
    end
    
    create_table :measurement_unit do |t|
      t.references :measurement
      t.references :unit_of_measure
    end
    
    create_table :aquatic_activity_events do |t|
      t.string    :project,                    :limit => 200
      t.string    :permit_no,                  :limit => 40
      t.integer   :aquatic_program_id  
      t.integer   :aquatic_activity_id         
      t.integer   :aquatic_activity_method_id  
      t.integer   :aquatic_site_id             
      t.timestamp :start_date            
      t.timestamp :end_date
      t.integer   :agency_id
      t.integer   :agency2_id
      t.string    :agency2_contact,            :limit => 100
      t.string    :activity_leader,            :limit => 100
      t.string    :crew,                       :limit => 100
      t.string    :weather_conditions,         :limit => 100
      t.float     :water_temperature_c
      t.float     :air_temperature_c
      t.string    :water_level,                :limit => 12
      t.string    :water_level_cm,             :limit => 100
      t.string    :morning_water_level_cm,     :limit => 100
      t.string    :evening_water_level_cm,     :limit => 100
      t.string    :siltation,                  :limit => 100
      t.boolean   :primary_activity
      t.string    :comments,                   :limit => 500      
      t.string    :rainfall_last24
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end

    add_index :aquatic_activity_events, [:aquatic_program_id]
    add_index :aquatic_activity_events, [:aquatic_activity_id]
    add_index :aquatic_activity_events, [:aquatic_activity_method_id]
    add_index :aquatic_activity_events, [:aquatic_site_id]
    add_index :aquatic_activity_events, [:agency_id]
    add_index :aquatic_activity_events, [:agency2_id]

    create_table :aquatic_sites do |t|
      t.string     :name,              :limit => 200
      t.string     :description,       :limit => 500
      t.string     :comments,          :limit => 300
      t.references :waterbody
      t.string     :coordinate_source, :limit => 100
      t.integer    :coordinate_srs_id
      t.string     :x_coordinate,      :limit => 100
      t.string     :y_coordinate,      :limit => 100
      t.integer    :gmap_srs_id
      t.decimal    :gmap_latitude,     :precision => 15, :scale => 10
      t.decimal    :gmap_longitude,    :precision => 15, :scale => 10
      t.timestamp  :imported_at
      t.timestamp  :exported_at
      t.timestamps
    end

    add_index :aquatic_sites, [:waterbody_id]

    create_table :aquatic_site_usages do |t|
      t.references :aquatic_site
      t.references :aquatic_activity
      t.string     :aquatic_site_type,   :limit => 60
      t.references :agency
      t.string     :agency_site_id,      :limit => 32
      t.string     :start_year,          :limit => 4
      t.string     :end_year,            :limit => 4
      t.string     :years_active,        :limit => 40      
      t.timestamp  :imported_at
      t.timestamp  :exported_at
      t.timestamps
    end

    add_index :aquatic_site_usages, [:aquatic_site_id]
    add_index :aquatic_site_usages, [:aquatic_activity_id]
    add_index :aquatic_site_usages, [:agency_id]
    
    create_table :water_chemistry_samples do |t|
      t.references :aquatic_activity_event
      t.string     :agency_sample_no,         :limit => 10
      t.float      :sample_depth_in_m
      t.string     :water_source_type,        :limit => 20
      t.string     :sample_collection_method
      t.string     :analyzed_by
      t.timestamp  :imported_at
      t.timestamp  :exported_at
      t.timestamps
    end
    
    create_table :water_chemistry_sample_results do |t|
      t.references :water_chemistry_sample
      t.references :water_chemistry_parameter
      t.references :instrument
      t.references :unit_of_measure      
      t.float      :value
      t.string     :qualifier
      t.string     :comment
    end
    
    create_table :water_chemistry_parameters do |t|
      t.string :name
      t.string :code
      t.timestamps
    end
    
    create_table :waterbodies do |t|
      t.string    :drainage_code,           :limit => 17
      t.string    :waterbody_type,          :limit => 8
      t.string    :name,                    :limit => 110
      t.string    :abbreviated_name,        :limit => 80
      t.string    :alt_name,                :limit => 80
      t.integer   :waterbody_complex_id     
      t.boolean   :surveyed                 
      t.integer   :flows_into_waterbody_id    
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end
  end

  def self.down
    drop_table :users
    drop_table :roles
    drop_table :permissions
    drop_table :agencies
    drop_table :aquatic_activities
    drop_table :aquatic_activity_methods
    drop_table :observations
    drop_table :observable_values
    drop_table :site_observations
    drop_table :measurements
    drop_table :site_measurements
    drop_table :instruments
    drop_table :measurement_instrument
    drop_table :measurement_unit
    drop_table :units_of_measure
    drop_table :aquatic_activity_events
    drop_table :aquatic_sites
    drop_table :aquatic_site_usages
    drop_table :water_chemistry_samples
    drop_table :water_chemistry_sample_results
    drop_table :water_chemistry_parameters
    drop_table :waterbodies
  end
end
