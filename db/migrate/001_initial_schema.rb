class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table "cdAgency", :force => true do |t|
      t.string "agencycd",     :limit => 5,  :null => false
      t.string "agency",       :limit => 60
      t.string "agencytype",   :limit => 4
      t.string "datarulesind", :limit => 1, :default => 'N'
      
      # TODO: move to enhanced table
      t.timestamps
      t.timestamp :imported_at
      t.timestamp :exported_at
    end
  
    create_table "cdAquaticActivity", :primary_key => "aquaticactivitycd", :force => true do |t|
      t.string  "aquaticactivity",         :limit => 50
      t.string  "aquaticactivitycategory", :limit => 30
      t.string  "duration",                :limit => 20
      
      # TODO: move to enhanced table
      t.timestamps
      t.timestamp :imported_at
      t.timestamp :exported_at
    end
  
    create_table "cdAquaticActivityMethod", :primary_key => "aquaticmethodcd", :force => true do |t|
      t.integer "aquaticactivitycd",               :default => 0
      t.string  "aquaticmethod",     :limit => 30
            
      # TODO: move to enhanced table
      t.timestamps
      t.timestamp :imported_at
      t.timestamp :exported_at
    end
  
    create_table "cdInstrument", :id => false, :force => true do |t|
      t.integer "instrumentcd",                       :null => false
      t.string  "instrument",          :limit => 50
      t.string  "instrument_category", :limit => 50
    end
  
    create_table "cdMeasureInstrument", :id => false, :force => true do |t|
      t.integer "measureinstrumentcd",                :null => false
      t.integer "oandmcd",             :default => 0
      t.integer "instrumentcd",        :default => 0
    end
  
    create_table "cdMeasureUnit", :id => false, :force => true do |t|
      t.integer "measureunitcd",                  :null => false
      t.integer "oandmcd",         :default => 0
      t.integer "unitofmeasurecd", :default => 0
    end
  
    create_table "cdOandM", :id => false, :force => true do |t|
      t.integer "oandmcd",                                           :null => false
      t.string  "oandm_type",      :limit => 16
      t.string  "oandm_category",  :limit => 40
      t.string  "oandm_group",     :limit => 50
      t.string  "oandm_parameter", :limit => 50
      t.boolean "oandm_valuesind",                :default => false
    end
  
    create_table "cdOandMValues", :id => false, :force => true do |t|
      t.integer "oandmvaluescd",                              :null => false
      t.integer "oandmcd",                     :default => 0
      t.string  "value",         :limit => 20
    end
  
    create_table "cdUnitofMeasure", :id => false, :force => true do |t|
      t.integer "unitofmeasurecd",                 :default => 0, :null => false
      t.string  "unitofmeasure",    :limit => 50
      t.string  "unitofmeasureabv", :limit => 10
    end
  
    create_table "cdWaterChemistryQualifier", :id => false, :force => true do |t|
      t.string "qualifiercd", :limit => 4
      t.string "qualifier",   :limit => 100
    end
  
    create_table "cdWaterParameter", :id => false, :force => true do |t|
      t.integer "waterparametercd",                :default => 0, :null => false
      t.string  "waterparameter",   :limit => 50
    end
  
    create_table "cdWaterSource", :id => false, :force => true do |t|
      t.string "watersourcecd",   :limit => 4,  :null => false
      t.string "watersource",     :limit => 20
      t.string "watersourcetype", :limit => 20
    end
    
    create_table "tblAquaticActivity", :id => false, :force => true do |t|
      t.integer  "aquaticactivityid",                                          :null => false
      t.integer  "tempaquaticactivityid"
      t.string   "project",                  :limit => 100
      t.string   "permitno",                 :limit => 20
      t.integer  "aquaticprogramid"
      t.integer  "aquaticactivitycd"
      t.integer  "aquaticmethodcd"
      t.integer  "oldaquaticsiteid"
      t.integer  "aquaticsiteid"
      t.string   "aquaticactivitystartdate", :limit => 10
      t.string   "aquaticactivityenddate",   :limit => 10
      t.string   "aquaticactivitystarttime", :limit => 6
      t.string   "aquaticactivityendtime",   :limit => 6
      t.string   "year",                     :limit => 4
      t.string   "agencycd",                 :limit => 4
      t.string   "agency2cd",                :limit => 4
      t.string   "agency2contact",           :limit => 50
      t.string   "aquaticactivityleader",    :limit => 50
      t.string   "crew",                     :limit => 50
      t.string   "weatherconditions",        :limit => 50
      t.float    "watertemp_c",              :limit => 2
      t.float    "airtemp_c",                :limit => 2
      t.string   "waterlevel",               :limit => 6
      t.string   "waterlevel_cm",            :limit => 50
      t.string   "waterlevel_am_cm",         :limit => 50
      t.string   "waterlevel_pm_cm",         :limit => 50
      t.string   "siltation",                :limit => 50
      t.boolean  "primaryactivityind",                      :default => false
      t.string   "comments",                 :limit => 250
      t.datetime "dateentered"
      t.boolean  "incorporatedind",                         :default => false
      t.datetime "datetransferred"
            
      # TODO: move to enhanced table
      t.datetime "start_date"
      t.datetime "end_date"
      t.string   "rainfall_last24",          :limit => 15
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "agency2_id",               :limit => 11
      t.integer  "agency_id",                :limit => 11
    end
  
    create_table "tblAquaticSite", :id => false, :force => true do |t|
      t.integer  "AquaticSiteId",                                      :null => false
      t.integer  "oldaquaticsiteid"
      t.integer  "riversystemid"
      t.integer  "WaterbodyId"
      t.string   "WaterbodyName",    :limit => 50
      t.string   "AquaticSiteName",  :limit => 100
      t.string   "AquaticSiteDesc",  :limit => 250
      t.string   "habitatdesc",      :limit => 50
      t.integer  "reachno"
      t.string   "startdesc",        :limit => 100
      t.string   "enddesc",          :limit => 100
      t.float    "startroutemeas"
      t.float    "endroutemeas"
      t.string   "sitetype",         :limit => 20
      t.string   "specificsiteind",  :limit => 1
      t.string   "georeferencedind", :limit => 1
      t.datetime "dateentered"
      t.boolean  "incorporatedind",                 :default => false
      t.string   "coordinatesource", :limit => 50
      t.string   "coordinatesystem", :limit => 50
      t.string   "xcoordinate",      :limit => 50
      t.string   "ycoordinate",      :limit => 50
      t.string   "coordinateunits",  :limit => 50
      t.string   "comments",         :limit => 50
      
      # TODO: move to enhanced table
      t.decimal  "gmap_latitude",                            :precision => 15, :scale => 10
      t.decimal  "gmap_longitude",                           :precision => 15, :scale => 10
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "tblAquaticSiteAgencyUse", :id => false, :force => true do |t|
      t.integer "aquaticsiteuseid",                                   :null => false
      t.integer "aquaticsiteid"
      t.integer "aquaticactivitycd"
      t.string  "aquaticsitetype",   :limit => 30
      t.string  "agencycd",          :limit => 4
      t.string  "agencysiteid",      :limit => 16
      t.string  "startyear",         :limit => 4
      t.string  "endyear",           :limit => 4
      t.string  "yearsactive",       :limit => 20
      t.boolean "incorporatedind",                 :default => false
    end
  
    create_table "tblDrainageUnit", :id => false, :force => true do |t|
      t.string    "drainagecd",     :limit => 17,  :null => false
      t.string    "level1no",       :limit => 2
      t.string    "level1name",     :limit => 40
      t.string    "level2no",       :limit => 2
      t.string    "level2name",     :limit => 50
      t.string    "level3no",       :limit => 2
      t.string    "level3name",     :limit => 50
      t.string    "level4no",       :limit => 2
      t.string    "level4name",     :limit => 50
      t.string    "level5no",       :limit => 2
      t.string    "level5name",     :limit => 50
      t.string    "level6no",       :limit => 2
      t.string    "level6name",     :limit => 50
      t.string    "unitname",       :limit => 55
      t.string    "unittype",       :limit => 4
      t.string    "borderind",      :limit => 1
      t.integer   "streamorder"
      t.float     "area_ha"
      t.float     "area_percent"
      t.string    "cgndb_key",      :limit => 10
      t.string    "drainsinto",     :limit => 40
    end
  
    create_table "tblEnvironmentalObservations", :id => false, :force => true do |t|
      t.integer   "envobservationid",                                            :null => false
      t.integer   "aquaticactivityid",                        :default => 0
      t.string    "observationgroup",          :limit => 50
      t.string    "observation",               :limit => 50
      t.string    "observationsupp",           :limit => 50
      t.integer   "pipesize_cm",                              :default => 0
      t.boolean   "fishpassageobstructionind",                :default => false
      t.timestamp "ssma_timestamp",                                              :null => false
    end
  
    create_table "tblObservations", :id => false, :force => true do |t|
      t.integer   "observationid",                                               :null => false
      t.integer   "aquaticactivityid"
      t.integer   "oandmcd"
      t.string    "oandm_other",               :limit => 50
      t.integer   "oandmvaluescd"
      t.integer   "pipesize_cm"
      t.boolean   "fishpassageobstructionind",                :default => false
      t.timestamp "ssma_timestamp",                                              :null => false
    end
  
    create_table "tblSiteMeasurement", :id => false, :force => true do |t|
      t.integer   "sitemeasurementid",               :null => false
      t.integer   "aquaticactivityid",               :null => false
      t.integer   "oandmcd"
      t.string    "oandm_other",       :limit => 20
      t.string    "bank",              :limit => 10
      t.integer   "instrumentcd"
      t.float     "measurement"
      t.integer   "unitofmeasurecd"
      t.timestamp "ssma_timestamp",                  :null => false
    end
    
    create_table "tblWaterBody", :id => false, :force => true do |t|
      t.integer  "waterbodyid",                           :null => false
      t.string   "cgndb_key",              :limit => 10
      t.string   "cgndb_key_alt",          :limit => 10
      t.string   "drainagecd",             :limit => 17
      t.string   "waterbodytypecd",        :limit => 4
      t.string   "waterbodyname",          :limit => 55
      t.string   "waterbodyname_abrev",    :limit => 40
      t.string   "waterbodyname_alt",      :limit => 40
      t.integer  "waterbodycomplexid"
      t.string   "surveyed_ind",           :limit => 1
      t.float    "flowsintowaterbodyid"
      t.string   "flowsintowaterbodyname", :limit => 40
      t.string   "flowintodrainagecd",     :limit => 17
      t.datetime "dateentered"
      t.datetime "datemodified"
    end
  
    create_table "tblWaterChemistryAnalysis", :id => false, :force => true do |t|
      t.integer "aquaticactivityid",                   :default => 0
      t.integer "tempaquaticactivityid",               :default => 0
      t.string  "doe_program",           :limit => 14
      t.string  "doe_projectno",         :limit => 10
      t.string  "doe_stationno",         :limit => 15
      t.string  "doe_labno",             :limit => 8
      t.string  "doe_fieldno",           :limit => 11
      t.float   "secchidepth_m"
      t.float   "sampledepth_m"
      t.float   "watertemp_c"
      t.float   "do"
      t.float   "toxic_unit"
      t.string  "l_hard",                :limit => 1
      t.float   "hard"
      t.float   "no3"
      t.string  "l_al_x",                :limit => 1
      t.float   "al_x"
      t.string  "l_al_xgf",              :limit => 1
      t.float   "al_xgf"
      t.string  "l_alk_g",               :limit => 1
      t.float   "alk_g"
      t.string  "l_alk_p",               :limit => 1
      t.float   "alk_p"
      t.string  "l_alk_t",               :limit => 1
      t.float   "alk_t"
      t.string  "l_as_xgf",              :limit => 1
      t.float   "as_xgf"
      t.string  "l_ba_x",                :limit => 1
      t.float   "ba_x"
      t.string  "l_b_x",                 :limit => 1
      t.float   "b_x"
      t.string  "l_br",                  :limit => 1
      t.float   "br"
      t.string  "l_ca_d",                :limit => 1
      t.float   "ca_d"
      t.string  "l_cd_xgf",              :limit => 1
      t.float   "cd_xgf"
      t.string  "l_chl_a",               :limit => 1
      t.float   "chl_a"
      t.string  "l_cl",                  :limit => 1
      t.float   "cl"
      t.string  "l_cl_ic",               :limit => 1
      t.float   "cl_ic"
      t.string  "l_clra",                :limit => 1
      t.float   "clra"
      t.string  "l_co_x",                :limit => 1
      t.float   "co_x"
      t.string  "l_cond",                :limit => 1
      t.float   "cond"
      t.float   "cond2",                               :default => 0.0
      t.string  "l_cr_x",                :limit => 1
      t.float   "cr_x"
      t.string  "l_cr_xgf",              :limit => 1
      t.float   "cr_xgf"
      t.string  "l_cu_x",                :limit => 1
      t.float   "cu_x"
      t.string  "l_cu_xgf",              :limit => 1
      t.float   "cu_xgf"
      t.string  "l_doc",                 :limit => 1
      t.float   "doc"
      t.string  "l_f",                   :limit => 1
      t.float   "f"
      t.string  "l_fe_x",                :limit => 1
      t.float   "fe_x"
      t.string  "l_hg_t",                :limit => 1
      t.float   "hg_t"
      t.string  "l_k",                   :limit => 1
      t.float   "k"
      t.string  "l_mg_d",                :limit => 1
      t.float   "mg_d"
      t.string  "l_mn_x",                :limit => 1
      t.float   "mn_x"
      t.string  "l_na",                  :limit => 1
      t.float   "na"
      t.string  "l_nh3t",                :limit => 1
      t.float   "nh3t"
      t.string  "l_ni_x",                :limit => 1
      t.float   "ni_x"
      t.string  "l_no2d",                :limit => 1
      t.float   "no2d"
      t.string  "l_nox",                 :limit => 1
      t.float   "nox"
      t.string  "l_pb_xgf",              :limit => 1
      t.float   "pb_xgf"
      t.string  "l_ph",                  :limit => 1
      t.float   "ph"
      t.string  "l_ph_gal",              :limit => 1
      t.float   "ph_gal"
      t.string  "l_sb_xgf",              :limit => 1
      t.float   "sb_xgf"
      t.string  "l_se_xgf",              :limit => 1
      t.float   "se_xgf"
      t.float   "silica",                              :default => 0.0
      t.string  "l_so4",                 :limit => 1
      t.float   "so4"
      t.string  "l_so4_ic",              :limit => 1
      t.float   "so4_ic"
      t.string  "l_ss",                  :limit => 1
      t.float   "ss"
      t.string  "l_tds",                 :limit => 1
      t.float   "tds"
      t.string  "l_tkn",                 :limit => 1
      t.float   "tkn"
      t.string  "l_tl_xgf",              :limit => 1
      t.float   "tl_xgf"
      t.string  "l_toc",                 :limit => 1
      t.float   "toc"
      t.string  "l_tp_l",                :limit => 1
      t.float   "tp_l"
      t.string  "l_turb",                :limit => 1
      t.float   "turb"
      t.string  "l_zn_x",                :limit => 1
      t.float   "zn_x"
      t.string  "l_zn_xgf",              :limit => 1
      t.float   "zn_xgf"
      t.string  "l_o_phos",              :limit => 1
      t.float   "o_phos",                              :default => 0.0
      t.float   "bicarb",                              :default => 0.0
      t.float   "carb",                                :default => 0.0
      t.float   "sat_ph",                              :default => 0.0
      t.float   "sat_ndx",                             :default => 0.0
    end
    
    create_table "tblWaterMeasurement", :id => false, :force => true do |t|
      t.integer "watermeasurementid",                                      :null => false
      t.integer "aquaticactivityid"
      t.integer "tempaquaticactivityid"
      t.integer "tempdataid"
      t.integer "temperatureloggerid"
      t.integer "habitatunitid"
      t.integer "sampleid"
      t.string  "watersourcetype",       :limit => 50
      t.float   "waterdepth_m",          :limit => 2
      t.string  "timeofday",             :limit => 5
      t.integer "oandmcd"
      t.integer "instrumentcd"
      t.float   "measurement",           :limit => 2
      t.integer "unitofmeasurecd"
      t.boolean "detectionlimitind",                    :default => false, :null => false
      t.string  "comment",               :limit => 255
    end
    
    create_table "aquatic_site_usages", :force => true do |t|
      t.integer  "aquatic_site_id",     :limit => 11
      t.integer  "aquatic_activity_id", :limit => 11
      t.string   "aquatic_site_type",   :limit => 60
      t.integer  "agency_id",           :limit => 11
      t.string   "agency_site_id",      :limit => 32
      t.string   "start_year",          :limit => 4
      t.string   "end_year",            :limit => 4
      t.string   "years_active",        :limit => 40
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "aquatic_sites", :force => true do |t|
      t.string   "name",                      :limit => 200
      t.string   "description",               :limit => 500
      t.string   "comments",                  :limit => 300
      t.integer  "waterbody_id",              :limit => 11
      t.decimal  "gmap_latitude",                            :precision => 15, :scale => 10
      t.decimal  "gmap_longitude",                           :precision => 15, :scale => 10
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "gmap_coordinate_system_id", :limit => 11
      t.integer  "coordinate_system_id",      :limit => 11
      t.string   "raw_longitude",             :limit => 20
      t.integer  "coordinate_source_id",      :limit => 11
      t.string   "raw_latitude",              :limit => 20
    end
    
    create_table "coordinate_sources", :force => true do |t|
      t.string "name", :limit => 30, :null => false
    end

    create_table "coordinate_sources_coordinate_systems", :id => false, :force => true do |t|
      t.integer "coordinate_system_id", :limit => 11, :null => false
      t.integer "coordinate_source_id", :limit => 11, :null => false
    end

    create_table "coordinate_systems", :force => true do |t|
      t.integer "epsg",         :limit => 11, :null => false
      t.string  "name",                       :null => false
      t.string  "display_name"
      t.string  "type",                       :null => false
    end

    create_table "instruments", :force => true do |t|
      t.string   "name",        :limit => 100
      t.string   "category",    :limit => 100
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "measurement_instrument", :force => true do |t|
      t.integer "measurement_id", :limit => 11
      t.integer "instrument_id",  :limit => 11
    end

    create_table "measurement_unit", :force => true do |t|
      t.integer "measurement_id",     :limit => 11
      t.integer "unit_of_measure_id", :limit => 11
    end

    create_table "measurements", :force => true do |t|
      t.string   "name"
      t.string   "grouping"
      t.string   "category"
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "bank_measurement", :default => false
    end

    create_table "observable_values", :force => true do |t|
      t.integer  "observation_id", :limit => 11
      t.string   "value"
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "observations", :force => true do |t|
      t.string   "name"
      t.string   "grouping"
      t.string   "category"
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "fish_passage_blocked_observation", :default => false
    end

    create_table "permissions", :force => true do |t|
      t.integer  "role_id",    :limit => 11, :null => false
      t.integer  "user_id",    :limit => 11, :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "roles", :force => true do |t|
      t.string   "rolename"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "site_measurements", :force => true do |t|
      t.integer  "aquatic_site_id",           :limit => 11
      t.integer  "aquatic_activity_event_id", :limit => 11
      t.integer  "measurement_id",            :limit => 11
      t.integer  "instrument_id",             :limit => 11
      t.integer  "unit_of_measure_id",        :limit => 11
      t.string   "value_measured"
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "bank"
    end

    create_table "site_observations", :force => true do |t|
      t.integer  "aquatic_site_id",           :limit => 11
      t.integer  "aquatic_activity_event_id", :limit => 11
      t.integer  "observation_id",            :limit => 11
      t.string   "value_observed"
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "fish_passage_blocked",                    :default => false
    end
    
    create_table "units_of_measure", :force => true do |t|
      t.string   "name",        :limit => 100
      t.string   "unit",        :limit => 20
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "users", :force => true do |t|
      t.string   "login"
      t.string   "email"
      t.string   "crypted_password",          :limit => 40
      t.string   "salt",                      :limit => 40
      t.string   "remember_token"
      t.datetime "remember_token_expires_at"
      t.string   "activation_code",           :limit => 40
      t.datetime "activated_at"
      t.string   "password_reset_code",       :limit => 40
      t.boolean  "enabled",                                 :default => true
      t.string   "agency_id", :limit => 5
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "last_login"
    end

    create_table "water_chemistry_parameters", :force => true do |t|
      t.string   "name"
      t.string   "code"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "imported_at"
      t.datetime "exported_at"
    end

    create_table "water_chemistry_sample_results", :force => true do |t|
      t.integer "water_chemistry_sample_id",    :limit => 11
      t.integer "water_chemistry_parameter_id", :limit => 11
      t.integer "instrument_id",                :limit => 11
      t.integer "unit_of_measure_id",           :limit => 11
      t.float   "value"
      t.string  "qualifier"
      t.string  "comment"
    end

    create_table "water_chemistry_samples", :force => true do |t|
      t.integer  "aquatic_activity_event_id", :limit => 11
      t.string   "agency_sample_no",          :limit => 10
      t.float    "sample_depth_in_m"
      t.string   "water_source_type",         :limit => 20
      t.string   "sample_collection_method"
      t.string   "analyzed_by"
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "waterbodies", :force => true do |t|
      t.string   "drainage_code",           :limit => 17
      t.string   "waterbody_type",          :limit => 8
      t.string   "name",                    :limit => 110
      t.string   "abbreviated_name",        :limit => 80
      t.string   "alt_name",                :limit => 80
      t.integer  "waterbody_complex_id",    :limit => 11
      t.boolean  "surveyed"
      t.integer  "flows_into_waterbody_id", :limit => 11
      t.datetime "imported_at"
      t.datetime "exported_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :cdAgency
    drop_table :cdAquaticActivity
    drop_table :cdAquaticActivityMethod
    drop_table :tblWaterMeasurement    
    drop_table :cdInstrument
    drop_table :cdMeasureInstrument
    drop_table :cdMeasureUnit
    drop_table :cdOandM
    drop_table :cdOandMValues
    drop_table :cdUnitofMeasure
    drop_table :cdWaterChemistryQualifier
    drop_table :cdWaterParameter
    drop_table :cdWaterSource    
    drop_table :tblAquaticActivity    
    drop_table :tblObservations    
    drop_table :tblAquaticSite    
    drop_table :tblAquaticSiteAgencyUse    
    drop_table :tblSiteMeasurement    
    drop_table :tblEnvironmentalObservations    
    drop_table :tblDrainageUnit
    drop_table :tblWaterBody
    drop_table :tblWaterChemistryAnalysis
    
    drop_table :aquatic_site_usages
    drop_table :aquatic_sites
    drop_table :coordinate_sources
    drop_table :coordinate_sources_coordinate_systems
    drop_table :coordinate_systems
    drop_table :instruments
    drop_table :measurement_instrument
    drop_table :measurement_unit
    drop_table :measurements
    drop_table :observable_values
    drop_table :observations
    drop_table :permissions
    drop_table :roles
    drop_table :site_measurements
    drop_table :site_observations
    drop_table :units_of_measure
    drop_table :users
    drop_table :water_chemistry_parameters
    drop_table :water_chemistry_sample_results
    drop_table :water_chemistry_samples
    drop_table :waterbodies
  end
end
