class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :agencies do |t|
      t.string    :code,       :limit => 10,  :null => false, :unique => true
      t.string    :name,       :limit => 120
      t.string    :type,       :limit => 8
      t.string    :data_rules, :limit => 2
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end

    create_table :aquatic_activities do |t|
      t.string :name,           :limit => 100, :unique => true
      t.string :category,       :limit => 60
      t.string :duration,       :limit => 40
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end

    create_table :aquatic_activity_methods do |t|
      t.integer :aquatic_activity_id
      t.string  :method,              :limit => 60
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end

    add_index :aquatic_activity_methods, [:aquatic_activity_id]

    create_table :instruments do |t|
      t.string :name,           :limit => 100
      t.string :category,       :limit => 100
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end

    create_table "cdmeasureinstrument", :primary_key => "measureinstrumentcd", :force => true do |t|
      t.integer "oandmcd"
      t.integer "instrumentcd"
    end

    add_index "cdmeasureinstrument", ["oandmcd"], :name => "index_cdMeasureInstrument_on_oandmcd"
    add_index "cdmeasureinstrument", ["instrumentcd"], :name => "index_cdMeasureInstrument_on_instrumentcd"

    create_table "cdmeasureunit", :primary_key => "measureunitcd", :force => true do |t|
      t.integer "oandmcd"
      t.integer "unitofmeasurecd"
    end

    add_index "cdmeasureunit", ["oandmcd"], :name => "index_cdMeasureUnit_on_oandmcd"
    add_index "cdmeasureunit", ["unitofmeasurecd"], :name => "index_cdMeasureUnit_on_unitofmeasurecd"

    create_table "cdoandm", :primary_key => "oandmcd", :force => true do |t|
      t.string  "oandm_type",        :limit => 32
      t.string  "oandm_category",    :limit => 80
      t.string  "oandm_group",       :limit => 100
      t.string  "oandm_parameter",   :limit => 100
      t.string  "oandm_parametercd", :limit => 60
      t.boolean "oandm_valuesind",                  :null => false
    end

    create_table "cdoandmvalues", :primary_key => "oandmvaluescd", :force => true do |t|
      t.integer "oandmcd"
      t.string  "value",   :limit => 40
    end

    add_index "cdoandmvalues", ["oandmcd"], :name => "index_cdOandMValues_on_oandmcd"

    create_table :measurement_units do |t|
      t.string :name,           :limit => 100
      t.string :unit,           :limit => 20
      t.timestamp :imported_at
      t.timestamp :exported_at
      t.timestamps
    end
    
    create_table "tblaquaticactivity", :primary_key => "aquaticactivityid", :force => true do |t|
      t.integer  "tempaquaticactivityid"
      t.string   "project",                  :limit => 200
      t.string   "permitno",                 :limit => 40
      t.integer  "aquaticprogramid"
      t.integer  "aquaticactivitycd"
      t.integer  "aquaticmethodcd"
      t.integer  "oldaquaticsiteid"
      t.integer  "aquaticsiteid"
      t.string   "aquaticactivitystartdate", :limit => 20
      t.string   "aquaticactivityenddate",   :limit => 20
      t.string   "aquaticactivitystarttime", :limit => 12
      t.string   "aquaticactivityendtime",   :limit => 12
      t.string   "year",                     :limit => 8
      t.string   "agencycd",                 :limit => 8
      t.string   "agency2cd",                :limit => 8
      t.string   "agency2contact",           :limit => 100
      t.string   "aquaticactivityleader",    :limit => 100
      t.string   "crew",                     :limit => 100
      t.string   "weatherconditions",        :limit => 100
      t.float    "watertemp_c"
      t.float    "airtemp_c"
      t.string   "waterlevel",               :limit => 12
      t.string   "waterlevel_cm",            :limit => 100
      t.string   "waterlevel_am_cm",         :limit => 100
      t.string   "waterlevel_pm_cm",         :limit => 100
      t.string   "siltation",                :limit => 100
      t.boolean  "primaryactivityind"
      t.string   "comments",                 :limit => 500
      t.datetime "dateentered"
      t.boolean  "incorporatedind"
      t.datetime "datetransferred"
      t.string   "rainfall_last24"
    end

    add_index "tblaquaticactivity", ["aquaticprogramid"], :name => "index_tblAquaticActivity_on_aquaticprogramid"
    add_index "tblaquaticactivity", ["aquaticactivitycd"], :name => "index_tblAquaticActivity_on_aquaticactivitycd"
    add_index "tblaquaticactivity", ["aquaticmethodcd"], :name => "index_tblAquaticActivity_on_aquaticmethodcd"
    add_index "tblaquaticactivity", ["oldaquaticsiteid"], :name => "index_tblAquaticActivity_on_oldaquaticsiteid"
    add_index "tblaquaticactivity", ["aquaticsiteid"], :name => "index_tblAquaticActivity_on_aquaticsiteid"
    add_index "tblaquaticactivity", ["agencycd"], :name => "index_tblAquaticActivity_on_agencycd"
    add_index "tblaquaticactivity", ["agency2cd"], :name => "index_tblAquaticActivity_on_agency2cd"

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

    create_table "tblaquaticsiteagencyuse", :primary_key => "aquaticsiteuseid", :force => true do |t|
      t.integer "aquaticsiteid"
      t.integer "aquaticactivitycd"
      t.string  "aquaticsitetype",   :limit => 60
      t.string  "agencycd",          :limit => 8
      t.string  "agencysiteid",      :limit => 32
      t.string  "startyear",         :limit => 8
      t.string  "endyear",           :limit => 8
      t.string  "yearsactive",       :limit => 40
      t.boolean "incorporatedind"
    end

    add_index "tblaquaticsiteagencyuse", ["aquaticsiteid"], :name => "index_tblAquaticSiteAgencyUse_on_aquaticsiteid"
    add_index "tblaquaticsiteagencyuse", ["aquaticactivitycd"], :name => "index_tblAquaticSiteAgencyUse_on_aquaticactivitycd"
    add_index "tblaquaticsiteagencyuse", ["agencycd"], :name => "index_tblAquaticSiteAgencyUse_on_agencycd"

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

    create_table "tblwaterbody", :primary_key => "waterbodyid", :force => true do |t|
      t.string   "cgndb_key",              :limit => 20
      t.string   "cgndb_key_alt",          :limit => 20
      t.string   "drainagecd",             :limit => 34
      t.string   "waterbodytypecd",        :limit => 8
      t.string   "waterbodyname",          :limit => 110
      t.string   "waterbodyname_abrev",    :limit => 80
      t.string   "waterbodyname_alt",      :limit => 80
      t.integer  "waterbodycomplexid"
      t.string   "surveyed_ind",           :limit => 2
      t.float    "flowsintowaterbodyid"
      t.string   "flowsintowaterbodyname", :limit => 80
      t.string   "flowintodrainagecd",     :limit => 34
      t.datetime "dateentered"
      t.datetime "datemodified"
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
  end

  def self.down
    drop_table :agencies
    drop_table :aquatic_activities
    drop_table :aquatic_activity_methods
    drop_table :instruments
    drop_table "cdmeasureinstrument"
    drop_table "cdmeasureunit"
    drop_table "cdoandm"
    drop_table "cdoandmvalues"
    drop_table :measurement_units
    drop_table "tblaquaticactivity"
    drop_table :aquatic_sites
    drop_table "tblaquaticsiteagencyuse"
    drop_table "tblenvironmentalobservations"
    drop_table "tblobservations"
    drop_table "tblsample"
    drop_table "tblsitemeasurement"
    drop_table "tblwaterbody"
    drop_table "tblwatermeasurement"
  end
end
