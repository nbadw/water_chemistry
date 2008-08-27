# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

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

  create_table "cdagency", :primary_key => "AgencyCd", :force => true do |t|
    t.string "Agency",       :limit => 60
    t.string "AgencyType",   :limit => 4
    t.string "DataRulesInd", :limit => 1
  end

  create_table "cdaquaticactivity", :primary_key => "AquaticActivityCd", :force => true do |t|
    t.string "AquaticActivity",         :limit => 50
    t.string "AquaticActivityCategory", :limit => 30
    t.string "Duration",                :limit => 20
  end

  create_table "cdaquaticactivitymethod", :primary_key => "AquaticMethodCd", :force => true do |t|
    t.integer "AquaticActivityCd", :limit => 11, :default => 0
    t.string  "AquaticMethod",     :limit => 30
  end

  create_table "cdinstrument", :primary_key => "InstrumentCd", :force => true do |t|
    t.string "Instrument",          :limit => 50
    t.string "Instrument_Category", :limit => 50
  end

  create_table "cdmeasureinstrument", :primary_key => "MeasureInstrumentCd", :force => true do |t|
    t.integer "InstrumentCd", :limit => 11, :default => 0
    t.integer "OandMCd",      :limit => 11, :default => 0
  end

  create_table "cdmeasureunit", :primary_key => "MeasureUnitCd", :force => true do |t|
    t.integer "OandMCd",         :limit => 11, :default => 0
    t.integer "UnitofMeasureCd", :limit => 11, :default => 0
  end

  create_table "cdoandm", :primary_key => "OandMCd", :force => true do |t|
    t.string  "OandM_Category",  :limit => 40
    t.string  "OandM_Group",     :limit => 50
    t.string  "OandM_Parameter", :limit => 50
    t.string  "OandM_Type",      :limit => 16
    t.boolean "OandM_ValuesInd"
  end

  create_table "cdoandmvalues", :primary_key => "OandMValuesCd", :force => true do |t|
    t.integer "OandMCd", :limit => 11, :default => 0
    t.string  "Value",   :limit => 20
  end

  create_table "cdunitofmeasure", :primary_key => "UnitofMeasureCd", :force => true do |t|
    t.string "UnitofMeasure",    :limit => 50
    t.string "UnitofMeasureAbv", :limit => 10
  end

  create_table "cdwaterchemistryqualifier", :id => false, :force => true do |t|
    t.string "Qualifier",   :limit => 100
    t.string "QualifierCd", :limit => 4
  end

  create_table "cdwaterparameter", :primary_key => "WaterParameterCd", :force => true do |t|
    t.string "WaterParameter", :limit => 50
  end

  create_table "cdwatersource", :id => false, :force => true do |t|
    t.string "WaterSource",     :limit => 20
    t.string "WaterSourceCd",   :limit => 4
    t.string "WaterSourceType", :limit => 20
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

  create_table "tblaquaticactivity", :primary_key => "AquaticActivityCd", :force => true do |t|
    t.string   "Agency2Cd",                :limit => 4
    t.string   "Agency2Contact",           :limit => 50
    t.string   "AgencyCd",                 :limit => 4
    t.float    "AirTemp_C"
    t.string   "AquaticActivityEndDate",   :limit => 10
    t.string   "AquaticActivityEndTime",   :limit => 6
    t.integer  "AquaticActivityID",        :limit => 11
    t.string   "AquaticActivityLeader",    :limit => 50
    t.string   "AquaticActivityStartDate", :limit => 10
    t.string   "AquaticActivityStartTime", :limit => 6
    t.integer  "AquaticMethodCd",          :limit => 11
    t.integer  "AquaticProgramID",         :limit => 11
    t.integer  "AquaticSiteID",            :limit => 11
    t.string   "Comments",                 :limit => 250
    t.string   "Crew",                     :limit => 50
    t.datetime "DateEntered"
    t.datetime "DateTransferred"
    t.boolean  "IncorporatedInd"
    t.integer  "oldAquaticSiteID",         :limit => 11
    t.string   "PermitNo",                 :limit => 20
    t.boolean  "PrimaryActivityInd"
    t.string   "Project",                  :limit => 100
    t.string   "Siltation",                :limit => 50
    t.integer  "TempAquaticActivityID",    :limit => 11
    t.string   "WaterLevel",               :limit => 6
    t.string   "WaterLevel_AM_cm",         :limit => 50
    t.string   "WaterLevel_cm",            :limit => 50
    t.string   "WaterLevel_PM_cm",         :limit => 50
    t.float    "WaterTemp_C"
    t.string   "WeatherConditions",        :limit => 50
    t.string   "Year",                     :limit => 4
  end

  create_table "tblaquaticsite", :primary_key => "AquaticSiteID", :force => true do |t|
    t.string   "AquaticSiteDesc",  :limit => 250
    t.string   "AquaticSiteName",  :limit => 100
    t.string   "Comments",         :limit => 150
    t.string   "CoordinateSource", :limit => 50
    t.string   "CoordinateSystem", :limit => 50
    t.string   "CoordinateUnits",  :limit => 50
    t.datetime "DateEntered"
    t.string   "EndDesc",          :limit => 100
    t.integer  "EndRouteMeas",     :limit => 10,  :precision => 10, :scale => 0
    t.string   "GeoReferencedInd", :limit => 1
    t.string   "HabitatDesc",      :limit => 50
    t.boolean  "IncorporatedInd"
    t.integer  "oldAquaticSiteID", :limit => 11
    t.integer  "ReachNo",          :limit => 11
    t.integer  "RiverSystemID",    :limit => 11
    t.string   "SiteType",         :limit => 20
    t.string   "SpecificSiteInd",  :limit => 1
    t.string   "StartDesc",        :limit => 100
    t.integer  "StartRouteMeas",   :limit => 10,  :precision => 10, :scale => 0
    t.integer  "WaterBodyID",      :limit => 11
    t.string   "WaterBodyName",    :limit => 50
    t.string   "XCoordinate",      :limit => 50
    t.string   "YCoordinate",      :limit => 50
  end

  create_table "tblaquaticsiteagencyuse", :primary_key => "AquaticSiteUseID", :force => true do |t|
    t.string   "AgencyCd",          :limit => 4
    t.string   "AgencySiteID",      :limit => 16
    t.integer  "AquaticActivityCd", :limit => 11
    t.integer  "AquaticSiteID",     :limit => 11
    t.string   "AquaticSiteType",   :limit => 30
    t.datetime "DateEntered"
    t.string   "EndYear",           :limit => 4
    t.boolean  "IncorporatedInd"
    t.string   "StartYear",         :limit => 4
    t.string   "YearsActive",       :limit => 20
  end

  create_table "tbldrainageunit", :primary_key => "DrainageCd", :force => true do |t|
    t.integer "Area_ha",      :limit => 10, :precision => 10, :scale => 0
    t.integer "Area_percent", :limit => 10, :precision => 10, :scale => 0
    t.string  "BorderInd",    :limit => 1
    t.string  "Level1Name",   :limit => 40
    t.string  "Level1No",     :limit => 2
    t.string  "Level2Name",   :limit => 50
    t.string  "Level2No",     :limit => 2
    t.string  "Level3Name",   :limit => 50
    t.string  "Level3No",     :limit => 2
    t.string  "Level4Name",   :limit => 50
    t.string  "Level4No",     :limit => 2
    t.string  "Level5Name",   :limit => 50
    t.string  "Level5No",     :limit => 2
    t.string  "Level6Name",   :limit => 50
    t.string  "Level6No",     :limit => 2
    t.integer "StreamOrder",  :limit => 11
    t.string  "UnitName",     :limit => 55
    t.string  "UnitType",     :limit => 4
  end

  create_table "tblenvironmentalobservations", :primary_key => "EnvObservationID", :force => true do |t|
    t.integer "AquaticActivityID",         :limit => 11, :default => 0
    t.boolean "FishPassageObstructionInd"
    t.string  "Observation",               :limit => 50
    t.string  "ObservationGroup",          :limit => 50
    t.string  "ObservationSupp",           :limit => 50
    t.integer "PipeSize_cm",               :limit => 11, :default => 0
  end

  create_table "tblobservations", :primary_key => "ObservationID", :force => true do |t|
    t.integer "AquaticActivityID",         :limit => 11
    t.boolean "FishPassageObstructionInd"
    t.string  "OandM_Other",               :limit => 50
    t.integer "OandMCd",                   :limit => 11
    t.integer "OandMValuesCd",             :limit => 11
    t.integer "PipeSize_cm",               :limit => 11
  end

  create_table "tblsitemeasurement", :primary_key => "SiteMeasurementID", :force => true do |t|
    t.integer "AquaticActivityID", :limit => 11,                                :null => false
    t.string  "Bank",              :limit => 10
    t.integer "InstrumentCd",      :limit => 11
    t.integer "Measurement",       :limit => 10, :precision => 10, :scale => 0
    t.string  "OandM_Other",       :limit => 20
    t.integer "OandMCd",           :limit => 11
    t.integer "UnitofMeasureCd",   :limit => 11
  end

  create_table "tblwaterbody", :primary_key => "WaterBodyID", :force => true do |t|
    t.datetime "DateEntered"
    t.datetime "DateModified"
    t.string   "DrainageCd",             :limit => 17
    t.string   "FlowIntoDrainageCd",     :limit => 17
    t.integer  "FlowsIntoWaterBodyID",   :limit => 10, :precision => 10, :scale => 0
    t.string   "FlowsIntoWaterBodyName", :limit => 40
    t.string   "Surveyed_Ind",           :limit => 1
    t.integer  "WaterBodyComplexID",     :limit => 11
    t.string   "WaterBodyName",          :limit => 55
    t.string   "WaterBodyName_Abrev",    :limit => 40
    t.string   "WaterBodyName_Alt",      :limit => 40
    t.string   "WaterBodyTypeCd",        :limit => 4
  end

  create_table "tblwaterchemistryanalysis", :id => false, :force => true do |t|
    t.integer "AL_X",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "AL_XGF",                :limit => 10, :precision => 10, :scale => 0
    t.integer "ALK_G",                 :limit => 10, :precision => 10, :scale => 0
    t.integer "ALK_P",                 :limit => 10, :precision => 10, :scale => 0
    t.integer "ALK_T",                 :limit => 10, :precision => 10, :scale => 0
    t.integer "AquaticActivityID",     :limit => 11,                                :default => 0
    t.integer "AS_XGF",                :limit => 10, :precision => 10, :scale => 0
    t.integer "B_X",                   :limit => 10, :precision => 10, :scale => 0
    t.integer "BA_X",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "BICARB",                :limit => 10, :precision => 10, :scale => 0, :default => 0
    t.integer "BR",                    :limit => 10, :precision => 10, :scale => 0
    t.integer "CA_D",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "CARB",                  :limit => 10, :precision => 10, :scale => 0, :default => 0
    t.integer "CD_XGF",                :limit => 10, :precision => 10, :scale => 0
    t.integer "CHL_A",                 :limit => 10, :precision => 10, :scale => 0
    t.integer "CL",                    :limit => 10, :precision => 10, :scale => 0
    t.integer "CL_IC",                 :limit => 10, :precision => 10, :scale => 0
    t.integer "CLRA",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "CO_X",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "COND",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "COND2",                 :limit => 10, :precision => 10, :scale => 0, :default => 0
    t.integer "CR_X",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "CR_XGF",                :limit => 10, :precision => 10, :scale => 0
    t.integer "CU_X",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "CU_XGF",                :limit => 10, :precision => 10, :scale => 0
    t.integer "DO",                    :limit => 10, :precision => 10, :scale => 0
    t.integer "DOC",                   :limit => 10, :precision => 10, :scale => 0
    t.string  "DOE_FieldNo",           :limit => 11
    t.string  "DOE_LabNo",             :limit => 8
    t.string  "DOE_Program",           :limit => 14
    t.string  "DOE_ProjectNo",         :limit => 10
    t.string  "DOE_StationNo",         :limit => 15
    t.integer "F",                     :limit => 10, :precision => 10, :scale => 0
    t.integer "FE_X",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "HARD",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "HG_T",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "K",                     :limit => 10, :precision => 10, :scale => 0
    t.string  "L_AL_X",                :limit => 1
    t.string  "L_AL_XGF",              :limit => 1
    t.string  "L_ALK_G",               :limit => 1
    t.string  "L_ALK_P",               :limit => 1
    t.string  "L_ALK_T",               :limit => 1
    t.string  "L_AS_XGF",              :limit => 1
    t.string  "L_B_X",                 :limit => 1
    t.string  "L_BA_X",                :limit => 1
    t.string  "L_BR",                  :limit => 1
    t.string  "L_CA_D",                :limit => 1
    t.string  "L_CD_XGF",              :limit => 1
    t.string  "L_CHL_A",               :limit => 1
    t.string  "L_CL",                  :limit => 1
    t.string  "L_CL_IC",               :limit => 1
    t.string  "L_CLRA",                :limit => 1
    t.string  "L_CO_X",                :limit => 1
    t.string  "L_COND",                :limit => 1
    t.string  "L_CR_X",                :limit => 1
    t.string  "L_CR_XGF",              :limit => 1
    t.string  "L_CU_X",                :limit => 1
    t.string  "L_CU_XGF",              :limit => 1
    t.string  "L_DOC",                 :limit => 1
    t.string  "L_F",                   :limit => 1
    t.string  "L_FE_X",                :limit => 1
    t.string  "L_HARD",                :limit => 1
    t.string  "L_HG_T",                :limit => 1
    t.string  "L_K",                   :limit => 1
    t.string  "L_MG_D",                :limit => 1
    t.string  "L_MN_X",                :limit => 1
    t.string  "L_NA",                  :limit => 1
    t.string  "L_NH3T",                :limit => 1
    t.string  "L_NI_X",                :limit => 1
    t.string  "L_NO2D",                :limit => 1
    t.string  "L_NOX",                 :limit => 1
    t.string  "L_O_PHOS",              :limit => 1
    t.string  "L_PB_XGF",              :limit => 1
    t.string  "L_PH",                  :limit => 1
    t.string  "L_PH_GAL",              :limit => 1
    t.string  "L_SB_XGF",              :limit => 1
    t.string  "L_SE_XGF",              :limit => 1
    t.string  "L_SO4",                 :limit => 1
    t.string  "L_SO4_IC",              :limit => 1
    t.string  "L_SS",                  :limit => 1
    t.string  "L_TDS",                 :limit => 1
    t.string  "L_TKN",                 :limit => 1
    t.string  "L_TL_XGF",              :limit => 1
    t.string  "L_TOC",                 :limit => 1
    t.string  "L_TP_L",                :limit => 1
    t.string  "L_TURB",                :limit => 1
    t.string  "L_ZN_X",                :limit => 1
    t.string  "L_ZN_XGF",              :limit => 1
    t.integer "MG_D",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "MN_X",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "NA",                    :limit => 10, :precision => 10, :scale => 0
    t.integer "NH3T",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "NI_X",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "NO2D",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "NO3",                   :limit => 10, :precision => 10, :scale => 0
    t.integer "NOX",                   :limit => 10, :precision => 10, :scale => 0
    t.integer "O_PHOS",                :limit => 10, :precision => 10, :scale => 0, :default => 0
    t.integer "PB_XGF",                :limit => 10, :precision => 10, :scale => 0
    t.integer "PH",                    :limit => 10, :precision => 10, :scale => 0
    t.integer "PH_GAL",                :limit => 10, :precision => 10, :scale => 0
    t.integer "SampleDepth_m",         :limit => 10, :precision => 10, :scale => 0
    t.integer "SAT_NDX",               :limit => 10, :precision => 10, :scale => 0, :default => 0
    t.integer "SAT_PH",                :limit => 10, :precision => 10, :scale => 0, :default => 0
    t.integer "SB_XGF",                :limit => 10, :precision => 10, :scale => 0
    t.integer "SE_XGF",                :limit => 10, :precision => 10, :scale => 0
    t.integer "SecchiDepth_m",         :limit => 10, :precision => 10, :scale => 0
    t.integer "SILICA",                :limit => 10, :precision => 10, :scale => 0, :default => 0
    t.integer "SO4",                   :limit => 10, :precision => 10, :scale => 0
    t.integer "SO4_IC",                :limit => 10, :precision => 10, :scale => 0
    t.integer "SS",                    :limit => 10, :precision => 10, :scale => 0
    t.integer "TDS",                   :limit => 10, :precision => 10, :scale => 0
    t.integer "TempAquaticActivityID", :limit => 11,                                :default => 0
    t.integer "TKN",                   :limit => 10, :precision => 10, :scale => 0
    t.integer "TL_XGF",                :limit => 10, :precision => 10, :scale => 0
    t.integer "TOC",                   :limit => 10, :precision => 10, :scale => 0
    t.integer "TOXIC_UNIT",            :limit => 10, :precision => 10, :scale => 0
    t.integer "TP_L",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "TURB",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "WaterTemp_C",           :limit => 10, :precision => 10, :scale => 0
    t.integer "ZN_X",                  :limit => 10, :precision => 10, :scale => 0
    t.integer "ZN_XGF",                :limit => 10, :precision => 10, :scale => 0
  end

  create_table "tblwatermeasurement", :primary_key => "WaterMeasurementID", :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 11
    t.integer "HabitatUnitID",         :limit => 11
    t.integer "InstrumentCd",          :limit => 11
    t.float   "Measurement"
    t.integer "OandMCd",               :limit => 11
    t.integer "TempAquaticActivityID", :limit => 11
    t.integer "TempDataID",            :limit => 11, :default => 0
    t.integer "TemperatureLoggerID",   :limit => 11, :default => 0
    t.string  "TimeofDay",             :limit => 5
    t.integer "UnitofMeasureCd",       :limit => 11
    t.float   "WaterDepth_m"
    t.string  "WaterSourceCd",         :limit => 50
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
    t.string   "agency_id",                 :limit => 5
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
