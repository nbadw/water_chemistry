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

    create_table :instruments do |t|
      t.string    :name,        :limit => 100
      t.string    :category,    :limit => 100
      t.timestamp :imported_at  
      t.timestamp :exported_at
      t.timestamps
    end
    
    create_table :observations do |t|
      t.references :observable
      t.references :observation, :polymorphic => true
      t.string     :value_observed
      t.timestamp  :imported_at  
      t.timestamp  :exported_at
      t.timestamps
    end
    
    create_table :observables do |t|      
      t.string    :name
      t.string    :group
      t.string    :category
      t.timestamp :imported_at  
      t.timestamp :exported_at
      t.timestamps
    end
    
    create_table :observable_values do |t|
      t.references :observable
      t.string     :value
      t.timestamp  :imported_at  
      t.timestamp  :exported_at
      t.timestamps
    end
        
    create_table :measurements do |t|
      t.references :measurement, :polymorphic => true
      t.references :instrument
      t.references :unit_of_measure
      t.string     :value_measured
      t.timestamp  :imported_at  
      t.timestamp  :exported_at
      t.timestamps
    end
    
    create_table :measurables do |t|
      t.string :name
      t.string :group
      t.string :category
      t.timestamp :imported_at  
      t.timestamp :exported_at
      t.timestamps
    end
    
#    create_table "cdmeasureinstrument", :primary_key => "measureinstrumentcd", :force => true do |t|
#      t.integer "oandmcd"
#      t.integer "instrumentcd"
#    end
#
#    add_index "cdmeasureinstrument", ["oandmcd"], :name => "index_cdMeasureInstrument_on_oandmcd"
#    add_index "cdmeasureinstrument", ["instrumentcd"], :name => "index_cdMeasureInstrument_on_instrumentcd"
#
#    create_table "cdmeasureunit", :primary_key => "measureunitcd", :force => true do |t|
#      t.integer "oandmcd"
#      t.integer "unitofmeasurecd"
#    end
#
#    add_index "cdmeasureunit", ["oandmcd"], :name => "index_cdMeasureUnit_on_oandmcd"
#    add_index "cdmeasureunit", ["unitofmeasurecd"], :name => "index_cdMeasureUnit_on_unitofmeasurecd"
#
#    create_table "cdoandm", :primary_key => "oandmcd", :force => true do |t|
#      t.string  "oandm_type",        :limit => 32
#      t.string  "oandm_category",    :limit => 80
#      t.string  "oandm_group",       :limit => 100
#      t.string  "oandm_parameter",   :limit => 100
#      t.string  "oandm_parametercd", :limit => 60
#      t.boolean "oandm_valuesind",                  :null => false
#    end
#
#    create_table "cdoandmvalues", :primary_key => "oandmvaluescd", :force => true do |t|
#      t.integer "oandmcd"
#      t.string  "value",   :limit => 40
#    end
#
#    add_index "cdoandmvalues", ["oandmcd"], :name => "index_cdOandMValues_on_oandmcd"

    create_table :units_of_measure do |t|
      t.string    :name,        :limit => 100
      t.string    :unit,        :limit => 20
      t.timestamp :imported_at  
      t.timestamp :exported_at
      t.timestamps
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
      t.string    :name,              :limit => 200
      t.string    :description,       :limit => 500
      t.string    :comments,          :limit => 300
      t.integer   :waterbody_id
      t.string    :coordinate_source, :limit => 100
      t.integer   :coordinate_srs_id
      t.string    :x_coordinate,      :limit => 100
      t.string    :y_coordinate,      :limit => 100
      t.integer   :gmap_srs_id
      t.decimal   :gmap_latitude,     :precision => 15, :scale => 10
      t.decimal   :gmap_longitude,    :precision => 15, :scale => 10
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end

    add_index :aquatic_sites, [:waterbody_id]

    create_table :aquatic_site_usages do |t|
      t.integer   :aquatic_site_id
      t.integer   :aquatic_activity_id
      t.string    :aquatic_site_type,   :limit => 60
      t.string    :agency_id,           :limit => 8
      t.string    :agency_site_id,      :limit => 32
      t.string    :start_year,          :limit => 4
      t.string    :end_year,            :limit => 4
      t.string    :years_active,        :limit => 40      
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end

    add_index :aquatic_site_usages, [:aquatic_site_id]
    add_index :aquatic_site_usages, [:aquatic_activity_id]
    add_index :aquatic_site_usages, [:agency_id]

    create_table "tblenvironmentalobservations", :primary_key => "envobservationid", :force => true do |t|
      t.integer "aquaticactivityid"
      t.string  "observationgroup",          :limit => 100
      t.string  "observation",               :limit => 100
      t.string  "observationsupp",           :limit => 100
      t.integer "pipesize_cm"
      t.boolean "fishpassageobstructionind"
    end

    add_index "tblenvironmentalobservations", ["aquaticactivityid"], :name => "index_tblEnvironmentalObservations_on_aquaticactivityid"

    create_table "tblobservations", :primary_key => "observationid", :force => true do |t|
      t.integer "aquaticactivityid"
      t.integer "oandmcd"
      t.string  "oandm_other",               :limit => 50
      t.string  "oandmvaluescd"
      t.integer "pipesize_cm"
      t.boolean "fishpassageobstructionind"
    end

    add_index "tblobservations", ["aquaticactivityid"], :name => "index_tblObservations_on_aquaticactivityid"

    create_table "tblsample", :primary_key => "sampleid", :force => true do |t|
      t.integer "aquaticactivityid"
      t.integer "tempaquaticactivityid"
      t.string  "agencysampleno",           :limit => 20
      t.float   "sampledepth_m"
      t.string  "watersourcetype",          :limit => 40
      t.string  "samplecollectionmethodcd"
      t.string  "analyzedby",               :limit => 510
    end

    add_index "tblsample", ["aquaticactivityid"], :name => "index_tblSample_on_aquaticactivityid"

    create_table "tblsitemeasurement", :primary_key => "sitemeasurementid", :force => true do |t|
      t.integer "aquaticactivityid"
      t.integer "oandmcd"
      t.string  "oandm_other"
      t.string  "bank"
      t.integer "instrumentcd"
      t.integer "measurement",       :limit => 10, :precision => 10, :scale => 0
      t.integer "unitofmeasurecd"
    end

    add_index "tblsitemeasurement", ["aquaticactivityid"], :name => "index_tblSiteMeasurement_on_aquaticactivityid"

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

    create_table "tblwatermeasurement", :primary_key => "watermeasurementid", :force => true do |t|
      t.integer "aquaticactivityid"
      t.integer "tempaquaticactivityid"
      t.integer "tempdataid"
      t.integer "temperatureloggerid"
      t.integer "habitatunitid"
      t.integer "sampleid"
      t.string  "watersourcetype",       :limit => 100
      t.float   "waterdepth_m"
      t.string  "timeofday",             :limit => 10
      t.integer "oandmcd"
      t.integer "instrumentcd"
      t.float   "measurement"
      t.integer "unitofmeasurecd"
      t.boolean "detectionlimitind",                    :null => false
      t.string  "comment",               :limit => 510
    end

    add_index "tblwatermeasurement", ["aquaticactivityid"], :name => "index_tblWaterMeasurement_on_aquaticactivityid"
    add_index "tblwatermeasurement", ["tempaquaticactivityid"], :name => "index_tblWaterMeasurement_on_tempaquaticactivityid"
    add_index "tblwatermeasurement", ["tempdataid"], :name => "index_tblWaterMeasurement_on_tempdataid"
    add_index "tblwatermeasurement", ["temperatureloggerid"], :name => "index_tblWaterMeasurement_on_temperatureloggerid"
    add_index "tblwatermeasurement", ["habitatunitid"], :name => "index_tblWaterMeasurement_on_habitatunitid"
    add_index "tblwatermeasurement", ["sampleid"], :name => "index_tblWaterMeasurement_on_sampleid"
    add_index "tblwatermeasurement", ["oandmcd"], :name => "index_tblWaterMeasurement_on_oandmcd"
    add_index "tblwatermeasurement", ["instrumentcd"], :name => "index_tblWaterMeasurement_on_instrumentcd"
    add_index "tblwatermeasurement", ["unitofmeasurecd"], :name => "index_tblWaterMeasurement_on_unitofmeasurecd"
    
    create_table :parameters do |t|
      t.string :name
      t.string :code
      t.timestamps
    end
    
    create_table :sample_results do |t|
      t.integer :sample_id,    :null => false
      t.integer :parameter_id, :null => false
      t.float   :value
      t.string  :qualifier
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
    drop_table :instruments
    drop_table :observables
    drop_table :observable_values
    drop_table :observations
    drop_table :measurables
    drop_table :measurements
    drop_table :units_of_measure
    drop_table :aquatic_activity_events
    drop_table :aquatic_sites
    drop_table :aquatic_site_usages
    drop_table "tblenvironmentalobservations"
    drop_table "tblobservations"
    drop_table "tblsample"
    drop_table "tblsitemeasurement"
    drop_table :waterbodies
    drop_table "tblwatermeasurement"
    drop_table :parameters
    drop_table :sample_results    
  end
end
