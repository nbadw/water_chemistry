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
    t.integer "AquaticActivityCd", :limit => 5
    t.string  "AquaticMethod",     :limit => 30
  end

  create_table "cdcountyparish", :primary_key => "CountyParishID", :force => true do |t|
    t.string "OldCountyCd",       :limit => 10
    t.string "NewCountyCd",       :limit => 11
    t.string "County",            :limit => 17
    t.string "OldParishCd",       :limit => 10
    t.string "NewParishCd",       :limit => 12
    t.string "Parish",            :limit => 22
    t.string "OldCountyParishCd", :limit => 6
    t.string "NewCountyParishCd", :limit => 7
  end

  add_index "cdcountyparish", ["CountyParishID"], :name => "CountyParishID"
  add_index "cdcountyparish", ["NewCountyCd"], :name => "NewCountyCd"
  add_index "cdcountyparish", ["NewParishCd"], :name => "NewParishCd"

  create_table "cdenvironmentalobservations", :primary_key => "ObservationID", :force => true do |t|
    t.string "ObservationCategory", :limit => 40
    t.string "ObservationGroup",    :limit => 50
    t.string "Observation",         :limit => 50
  end

  add_index "cdenvironmentalobservations", ["ObservationID"], :name => "ObservationID"

  create_table "cdfishageclass", :primary_key => "FishAgeClass", :force => true do |t|
    t.string  "FishAgeClassCategory", :limit => 20
    t.boolean "StockingInd",                        :null => false
    t.boolean "ElectrofishInd",                     :null => false
    t.boolean "FishCountInd",                       :null => false
  end

  create_table "cdfishmark", :primary_key => "FishMarkCd", :force => true do |t|
    t.string "FishMark", :limit => 50
  end

  add_index "cdfishmark", ["FishMarkCd"], :name => "Fin Status Code"

  create_table "cdfishmortalitycause", :primary_key => "MortalityCauseCd", :force => true do |t|
    t.string "CauseOfMortality", :limit => 50
  end

  create_table "cdfishparasiteclass", :primary_key => "ParasiteClassCd", :force => true do |t|
    t.string "ParasiteClass", :limit => 20
    t.string "Location",      :limit => 24
  end

  create_table "cdfishpopulationformula", :primary_key => "FormulaCd", :force => true do |t|
    t.string "Formula", :limit => 20
  end

  create_table "cdfishpopulationparameter", :id => false, :force => true do |t|
    t.string "PopulationParameter", :limit => 20
  end

  create_table "cdfishspecies", :primary_key => "FishSpeciesCd", :force => true do |t|
    t.string  "FishSpecies",    :limit => 30
    t.boolean "StockedInd",                   :null => false
    t.boolean "ElectrofishInd",               :null => false
  end

  create_table "cdfishstatus", :primary_key => "FishStatusCd", :force => true do |t|
    t.string "FishStatus",     :limit => 50
    t.string "FishStatusType", :limit => 20
  end

  create_table "cdfishstomachcontent", :primary_key => "StomachContentCd", :force => true do |t|
    t.string "StomachContent", :limit => 20
  end

  create_table "cdhabitatunitcomment", :primary_key => "CommentCd", :force => true do |t|
    t.string "Comment", :limit => 30
  end

  create_table "cdinstrument", :primary_key => "InstrumentCd", :force => true do |t|
    t.string "Instrument",          :limit => 50
    t.string "Instrument_Category", :limit => 50
  end

  create_table "cdmeasureinstrument", :primary_key => "MeasureInstrumentCd", :force => true do |t|
    t.integer "OandMCd",      :limit => 10
    t.integer "InstrumentCd", :limit => 10
  end

  create_table "cdmeasureunit", :primary_key => "MeasureUnitCd", :force => true do |t|
    t.integer "OandMCd",         :limit => 10
    t.integer "UnitofMeasureCd", :limit => 10
  end

  create_table "cdoandm", :primary_key => "OandMCd", :force => true do |t|
    t.string  "OandM_Type",      :limit => 16
    t.string  "OandM_Category",  :limit => 40
    t.string  "OandM_Group",     :limit => 50
    t.string  "OandM_Parameter", :limit => 50
    t.boolean "OandM_ValuesInd",               :null => false
  end

  add_index "cdoandm", ["OandMCd"], :name => "ObservationID"

  create_table "cdoandmvalues", :primary_key => "OandMValuesCd", :force => true do |t|
    t.integer "OandMCd", :limit => 10
    t.string  "Value",   :limit => 20
  end

  add_index "cdoandmvalues", ["OandMCd"], :name => "cdOandMcdOandMValues"
  add_index "cdoandmvalues", ["OandMCd"], :name => "O&M_ID"

  create_table "cdsamplegear", :primary_key => "SampleGearCd", :force => true do |t|
    t.string "SampleGear", :limit => 20
  end

  create_table "cdsex", :primary_key => "SexCd", :force => true do |t|
    t.string "Sex", :limit => 10
  end

  create_table "cdstreamchanneltype", :primary_key => "ChannelCd", :force => true do |t|
    t.string "ChannelType", :limit => 6
  end

  create_table "cdstreamembeddedness", :primary_key => "EmbeddedCd", :force => true do |t|
    t.string "Embeddedness", :limit => 10
  end

  create_table "cdstreamtype", :primary_key => "StreamTypeCd", :force => true do |t|
    t.string "StreamType",      :limit => 24
    t.string "StreamTypeGroup", :limit => 6
  end

  create_table "cdtranslation - asf species", :id => false, :force => true do |t|
    t.string "ASF_Species",  :limit => 50
    t.string "DW_SpeciesCd", :limit => 2
    t.string "DW_Species",   :limit => 40
  end

  create_table "cdtranslation - dfo electrofishingsite(juvenile surveys)", :id => false, :force => true do |t|
    t.integer "AquaticSiteID",          :limit => 10
    t.string  "Site",                   :limit => 50
    t.string  "Agency"
    t.string  "River"
    t.integer "MinOfAquaticActivityID", :limit => 10
  end

  add_index "cdtranslation - dfo electrofishingsite(juvenile surveys)", ["AquaticSiteID"], :name => "AquaticSiteID"
  add_index "cdtranslation - dfo electrofishingsite(juvenile surveys)", ["MinOfAquaticActivityID"], :name => "MinOfAquaticActivityID"

  create_table "cdtranslation - dfo electrofishingsite(miramichi)", :id => false, :force => true do |t|
    t.integer "AquaticSiteID",          :limit => 10
    t.string  "Site",                   :limit => 50
    t.string  "Agency"
    t.string  "River"
    t.integer "MinOfAquaticActivityID", :limit => 10
  end

  add_index "cdtranslation - dfo electrofishingsite(miramichi)", ["AquaticSiteID"], :name => "AquaticSiteID"
  add_index "cdtranslation - dfo electrofishingsite(miramichi)", ["MinOfAquaticActivityID"], :name => "MinOfAquaticActivityID"

  create_table "cdtranslation - dfo electrofishingsite(restigouche)", :primary_key => "ID", :force => true do |t|
    t.integer "AquaticSiteID",   :limit => 10
    t.string  "RiverSystem"
    t.string  "Stream"
    t.string  "SiteDescription"
    t.string  "SiteCode"
    t.string  "SiteType"
    t.string  "Latitude"
    t.string  "Longitude"
    t.string  "Accuracy"
    t.string  "PhotoNumber"
    t.string  "Comment"
    t.string  "Field11"
  end

  add_index "cdtranslation - dfo electrofishingsite(restigouche)", ["AquaticSiteID"], :name => "AquaticSiteID"
  add_index "cdtranslation - dfo electrofishingsite(restigouche)", ["SiteCode"], :name => "SiteCode"

  create_table "cdtranslation - dfo electrofishingsite(tabusintac)", :primary_key => "OID", :force => true do |t|
    t.integer "AquaticSiteID", :limit => 10
    t.string  "EFSITE_ID",     :limit => 50
    t.integer "WATER_ID",      :limit => 10
    t.string  "WATER_NAME",    :limit => 40
    t.string  "DRAINGE_CD",    :limit => 17
    t.string  "AGENCY_CD",     :limit => 4
    t.string  "AGENCY2_CD",    :limit => 50
    t.string  "AG_SITE_ID",    :limit => 6
    t.string  "AG2SITE_ID",    :limit => 50
    t.string  "SITE_DES"
    t.string  "HABUNIT_ID",    :limit => 50
    t.string  "STRTYP_DES",    :limit => 50
    t.string  "START_YR",      :limit => 50
    t.string  "END_YR",        :limit => 50
    t.string  "AG2_ST_YR",     :limit => 50
    t.string  "AG2_END_YEAR",  :limit => 50
  end

  add_index "cdtranslation - dfo electrofishingsite(tabusintac)", ["AG2SITE_ID"], :name => "AG2SITE_ID"
  add_index "cdtranslation - dfo electrofishingsite(tabusintac)", ["AG_SITE_ID"], :name => "AgSiteID"
  add_index "cdtranslation - dfo electrofishingsite(tabusintac)", ["AquaticSiteID"], :name => "AquaticSiteID"
  add_index "cdtranslation - dfo electrofishingsite(tabusintac)", ["EFSITE_ID"], :name => "EFSITE_ID"
  add_index "cdtranslation - dfo electrofishingsite(tabusintac)", ["HABUNIT_ID"], :name => "HABUNIT_ID"
  add_index "cdtranslation - dfo electrofishingsite(tabusintac)", ["WATER_ID"], :name => "WATER_ID"

  create_table "cdtranslation - dfo hatchery", :id => false, :force => true do |t|
    t.integer "Facility Code", :limit => 10
    t.float   "HCODE",         :limit => 15
    t.string  "Name",          :limit => 20
    t.string  "Active",        :limit => 1
    t.string  "Comments",      :limit => 50
  end

  add_index "cdtranslation - dfo hatchery", ["Facility Code"], :name => "Facility Code"
  add_index "cdtranslation - dfo hatchery", ["HCODE"], :name => "HCODE"

  create_table "cdtranslation - dfo llsalmon stock", :id => false, :force => true do |t|
    t.integer "DWFishStockID",  :limit => 10
    t.float   "DFOFishStockCd", :limit => 15
    t.string  "Stock",          :limit => 100
  end

  add_index "cdtranslation - dfo llsalmon stock", ["DFOFishStockCd"], :name => "Code"
  add_index "cdtranslation - dfo llsalmon stock", ["DWFishStockID"], :name => "DWFishStockID"

  create_table "cdtranslation - dfo mark", :id => false, :force => true do |t|
    t.integer "cdFishMark",  :limit => 10
    t.float   "Mark_Cd",     :limit => 15
    t.string  "Description", :limit => 50
  end

  create_table "cdtranslation - dfo salmon stock", :id => false, :force => true do |t|
    t.float   "DFOStockCd",  :limit => 15
    t.string  "Stock"
    t.integer "FishStockID", :limit => 10
    t.integer "Mating Cd",   :limit => 10
    t.string  "Mating",      :limit => 150
  end

  add_index "cdtranslation - dfo salmon stock", ["DFOStockCd"], :name => "Code"
  add_index "cdtranslation - dfo salmon stock", ["FishStockID"], :name => "FishStockID"

  create_table "cdtranslation - dfo species", :id => false, :force => true do |t|
    t.string "DW speciesCode", :limit => 2
    t.string "DFO spec_cd",    :limit => 1
    t.string "Name",           :limit => 30
    t.string "fish age class", :limit => 10
  end

  add_index "cdtranslation - dfo species", ["DW speciesCode"], :name => "speciesCode"

  create_table "cdtranslation - dfo stage", :id => false, :force => true do |t|
    t.string "FishAgeClass", :limit => 15
    t.string "Stage_cd",     :limit => 3
    t.string "Description",  :limit => 50
    t.string "Common_Name",  :limit => 15
  end

  create_table "cdtranslation - dfo stock mating", :primary_key => "Mating Code", :force => true do |t|
    t.string "Mating", :limit => 150
  end

  add_index "cdtranslation - dfo stock mating", ["Mating Code"], :name => "Mating Code"

  create_table "cdtranslation - dfo stocking site", :primary_key => "ID", :force => true do |t|
    t.float  "SCODE",      :limit => 15
    t.float  "AQUASITEID", :limit => 15
    t.float  "WATER_ID",   :limit => 15
    t.string "AG_SITE_ID", :limit => 15
    t.string "AQSITEIND",  :limit => 1
    t.string "LOCATION"
    t.string "WATER_NAME"
    t.string "WATER_ALT"
    t.float  "RIVER",      :limit => 15
    t.string "TYPE",       :limit => 2
    t.string "LAT",        :limit => 4
    t.string "LON",        :limit => 4
    t.string "COMMENTS",   :limit => 50
  end

  add_index "cdtranslation - dfo stocking site", ["AG_SITE_ID"], :name => "AG_SITE_ID"
  add_index "cdtranslation - dfo stocking site", ["AQUASITEID"], :name => "AQUASITEID"
  add_index "cdtranslation - dfo stocking site", ["SCODE"], :name => "SCODE"
  add_index "cdtranslation - dfo stocking site", ["WATER_ID"], :name => "WATER_ID"

  create_table "cdtranslation - dfo trout stock", :id => false, :force => true do |t|
    t.integer "DWFishStockID",    :limit => 10
    t.float   "DFOFishStockCode", :limit => 15
    t.string  "Stock"
    t.string  "Matings",          :limit => 150
  end

  add_index "cdtranslation - dfo trout stock", ["DFOFishStockCode"], :name => "Code"
  add_index "cdtranslation - dfo trout stock", ["DWFishStockID"], :name => "DWFishStockID"

  create_table "cdtranslation - dnr fish strain", :primary_key => "DWFishStockID", :force => true do |t|
    t.integer "DNRFishStockCd", :limit => 10
    t.string  "FishSpeciesCd",  :limit => 2
    t.integer "WaterBodyID",    :limit => 10
    t.string  "FishStockName",  :limit => 30
    t.string  "WildStatusCd",   :limit => 10
    t.string  "RunSeasonCd",    :limit => 50
    t.string  "Triploid_ind",   :limit => 50
  end

  add_index "cdtranslation - dnr fish strain", ["DWFishStockID"], :name => "DWFishStockID"
  add_index "cdtranslation - dnr fish strain", ["WaterBodyID"], :name => "WaterBodyID"

  create_table "cdtranslation - dnr siltation", :primary_key => "SiltationCd", :force => true do |t|
    t.string "SiltationDesc", :limit => 20
  end

  create_table "cdunitofmeasure", :primary_key => "UnitofMeasureCd", :force => true do |t|
    t.string "UnitofMeasure",    :limit => 50
    t.string "UnitofMeasureAbv", :limit => 10
  end

  create_table "cdwaterchemistryqualifier", :id => false, :force => true do |t|
    t.string "QualifierCd", :limit => 4
    t.string "Qualifier",   :limit => 100
  end

  create_table "cdwaterparameter", :primary_key => "WaterParameterCd", :force => true do |t|
    t.string "WaterParameter", :limit => 50
  end

  create_table "cdwaterparameterconversion-delete_after_conversion", :primary_key => "WaterParameterCd", :force => true do |t|
    t.integer "OandMCd",        :limit => 10
    t.string  "WaterParameter", :limit => 50
    t.integer "InstrumentCd",   :limit => 10
  end

  create_table "cdwatersource", :primary_key => "WaterSourceCd", :force => true do |t|
    t.string "WaterSource",     :limit => 20
    t.string "WaterSourceType", :limit => 20
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

  create_table "tblanglinglease", :primary_key => "RegulatedWaterID", :force => true do |t|
    t.integer "LeaseNo",         :limit => 5
    t.string  "LeaseDesc",       :limit => 254
    t.float   "StreamLength_km", :limit => 15
    t.integer "NoRodsPerDay",    :limit => 5
    t.string  "NoRodsPerYear",   :limit => 24
    t.string  "ExpiryYear",      :limit => 4
    t.string  "LodgeName",       :limit => 20
    t.string  "Lessee",          :limit => 45
    t.string  "LesseeAddress1",  :limit => 30
    t.string  "LesseeAddress2",  :limit => 20
    t.string  "LesseeCity",      :limit => 20
    t.string  "LesseProv",       :limit => 2
    t.string  "LesseePostalCd",  :limit => 7
    t.string  "Contact1",        :limit => 20
    t.string  "Contact1Title",   :limit => 20
    t.string  "Contact1Dept",    :limit => 25
    t.string  "Contact1Phone",   :limit => 14
    t.string  "Contact1Fax",     :limit => 14
    t.string  "Contact2",        :limit => 24
    t.string  "Contact2Title",   :limit => 20
    t.string  "Contact2Dept",    :limit => 20
    t.string  "Contact2Phone",   :limit => 14
    t.string  "Contact2Fax",     :limit => 14
    t.string  "Manager",         :limit => 21
    t.string  "ManagerPhone",    :limit => 14
  end

  add_index "tblanglinglease", ["RegulatedWaterID"], :name => "{D3655704-EBA1-41D7-8CCB-412119"
  add_index "tblanglinglease", ["LeaseNo"], :name => "LEASE_ID"
  add_index "tblanglinglease", ["RegulatedWaterID"], :name => "RegulatedWatersID"

  create_table "tblanglinglicensesales", :primary_key => "LicenseSalesID", :force => true do |t|
    t.integer "LicenseCd",    :limit => 10
    t.string  "Residence"
    t.string  "LicenseType"
    t.string  "LicenseClass"
    t.string  "LicenseDesc"
    t.integer "Year",         :limit => 10
    t.integer "NoSold",       :limit => 10
  end

  create_table "tblaquaticactivity", :primary_key => "AquaticActivityID", :force => true do |t|
    t.integer  "TempAquaticActivityID",    :limit => 10
    t.string   "Project",                  :limit => 100
    t.string   "PermitNo",                 :limit => 20
    t.integer  "AquaticProgramID",         :limit => 10
    t.integer  "AquaticActivityCd",        :limit => 5
    t.integer  "AquaticMethodCd",          :limit => 5
    t.integer  "oldAquaticSiteID",         :limit => 10
    t.integer  "AquaticSiteID",            :limit => 10
    t.string   "AquaticActivityStartDate", :limit => 10
    t.string   "AquaticActivityEndDate",   :limit => 10
    t.string   "AquaticActivityStartTime", :limit => 6
    t.string   "AquaticActivityEndTime",   :limit => 6
    t.string   "Year",                     :limit => 4
    t.string   "AgencyCd",                 :limit => 4
    t.string   "Agency2Cd",                :limit => 4
    t.string   "Agency2Contact",           :limit => 50
    t.string   "AquaticActivityLeader",    :limit => 50
    t.string   "Crew",                     :limit => 50
    t.string   "WeatherConditions",        :limit => 50
    t.float    "WaterTemp_C",              :limit => 7
    t.float    "AirTemp_C",                :limit => 7
    t.string   "WaterLevel",               :limit => 6
    t.string   "WaterLevel_cm",            :limit => 50
    t.string   "WaterLevel_AM_cm",         :limit => 50
    t.string   "WaterLevel_PM_cm",         :limit => 50
    t.string   "Siltation",                :limit => 50
    t.boolean  "PrimaryActivityInd",                      :null => false
    t.string   "Comments",                 :limit => 250
    t.datetime "DateEntered"
    t.boolean  "IncorporatedInd",                         :null => false
    t.datetime "DateTransferred"
  end

  add_index "tblaquaticactivity", ["AquaticSiteID"], :name => "{33D6B2E4-F11A-47D1-BFE4-EE52E8"
  add_index "tblaquaticactivity", ["AquaticMethodCd"], :name => "{662545B5-04AA-492B-833B-D9BED2"
  add_index "tblaquaticactivity", ["AquaticActivityCd"], :name => "{66945D2F-F4E9-46B3-B601-8B4AC0"
  add_index "tblaquaticactivity", ["AquaticProgramID"], :name => "{86A93E88-27E1-4293-8F8F-51509C"
  add_index "tblaquaticactivity", ["Agency2Cd"], :name => "{D79D562C-FC0D-4C7B-AF79-95EFDA"
  add_index "tblaquaticactivity", ["AgencyCd"], :name => "{DBF31B0D-A36E-42EC-A246-E33178"
  add_index "tblaquaticactivity", ["Agency2Cd"], :name => "{FFCC8125-2385-49D8-9E05-364C40"
  add_index "tblaquaticactivity", ["AquaticActivityID"], :name => "AquaticActivityID1"
  add_index "tblaquaticactivity", ["AquaticProgramID"], :name => "AquaticProgramID"
  add_index "tblaquaticactivity", ["AquaticSiteID"], :name => "FisheriesSiteID"
  add_index "tblaquaticactivity", ["TempAquaticActivityID"], :name => "OldAquaticActivityID"
  add_index "tblaquaticactivity", ["oldAquaticSiteID"], :name => "oldAquaticSiteID"

  create_table "tblaquaticprogram", :primary_key => "AquaticProgramID", :force => true do |t|
    t.string   "AquaticProgramName",      :limit => 30
    t.string   "AquaticProgramPurpose",   :limit => 150
    t.datetime "AquaticProgramStartDate"
    t.datetime "AquaticProgramEndDate"
    t.string   "AgencyCd",                :limit => 4
    t.string   "AquaticProgramLeader",    :limit => 50
  end

  add_index "tblaquaticprogram", ["AgencyCd"], :name => "{D2FEB2BB-F414-4F7D-8613-ACB906"
  add_index "tblaquaticprogram", ["AquaticProgramID"], :name => "AquaticProgramID"

  create_table "tblaquaticsite", :primary_key => "AquaticSiteID", :force => true do |t|
    t.integer  "oldAquaticSiteID", :limit => 10
    t.integer  "RiverSystemID",    :limit => 5
    t.integer  "WaterBodyID",      :limit => 10
    t.string   "WaterBodyName",    :limit => 50
    t.string   "AquaticSiteName",  :limit => 100
    t.string   "AquaticSiteDesc",  :limit => 250
    t.string   "HabitatDesc",      :limit => 50
    t.integer  "ReachNo",          :limit => 10
    t.string   "StartDesc",        :limit => 100
    t.string   "EndDesc",          :limit => 100
    t.float    "StartRouteMeas",   :limit => 15
    t.float    "EndRouteMeas",     :limit => 15
    t.string   "SiteType",         :limit => 20
    t.string   "SpecificSiteInd",  :limit => 1
    t.string   "GeoReferencedInd", :limit => 1
    t.datetime "DateEntered"
    t.boolean  "IncorporatedInd",                 :null => false
    t.string   "CoordinateSource", :limit => 50
    t.string   "CoordinateSystem", :limit => 50
    t.string   "XCoordinate",      :limit => 50
    t.string   "YCoordinate",      :limit => 50
    t.string   "CoordinateUnits",  :limit => 50
    t.string   "Comments",         :limit => 150
  end

  add_index "tblaquaticsite", ["WaterBodyID"], :name => "{047A49A9-3B29-47B9-B429-4EBFC4"
  add_index "tblaquaticsite", ["RiverSystemID"], :name => "{A85D1309-1E35-4A86-8D76-67637B"
  add_index "tblaquaticsite", ["AquaticSiteID"], :name => "AssmtSiteID"
  add_index "tblaquaticsite", ["oldAquaticSiteID"], :name => "oldAquaticSiteID"
  add_index "tblaquaticsite", ["RiverSystemID"], :name => "RiverSystemID"
  add_index "tblaquaticsite", ["WaterBodyID"], :name => "WaterBodyID"

  create_table "tblaquaticsiteagencyuse", :primary_key => "AquaticSiteUseID", :force => true do |t|
    t.integer  "AquaticSiteID",     :limit => 10
    t.integer  "AquaticActivityCd", :limit => 5
    t.string   "AquaticSiteType",   :limit => 30
    t.string   "AgencyCd",          :limit => 4
    t.string   "AgencySiteID",      :limit => 16
    t.string   "StartYear",         :limit => 4
    t.string   "EndYear",           :limit => 4
    t.string   "YearsActive",       :limit => 20
    t.datetime "DateEntered"
    t.boolean  "IncorporatedInd",                 :null => false
  end

  add_index "tblaquaticsiteagencyuse", ["AquaticSiteID"], :name => "{AE11D8D8-9E33-4740-BC97-E80094"
  add_index "tblaquaticsiteagencyuse", ["AgencySiteID"], :name => "AgencySiteID"
  add_index "tblaquaticsiteagencyuse", ["AquaticSiteUseID"], :name => "AssmtSiteID"
  add_index "tblaquaticsiteagencyuse", ["AquaticSiteID"], :name => "WaterBodyID"

  create_table "tblbacterialanalysis", :primary_key => "BacterialAnalysisID", :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.string  "DOE_LabNo",             :limit => 8
    t.string  "DOE_FieldNo",           :limit => 10
    t.float   "SampleDepth_m",         :limit => 15
    t.float   "WaterTemp_C",           :limit => 15
    t.string  "QualifierA",            :limit => 2
    t.float   "FaecalColiformCount_A", :limit => 15
    t.string  "QualifierB",            :limit => 2
    t.float   "FaecalColiformCount_B", :limit => 15
    t.string  "L_TotalColiforms",      :limit => 1
    t.integer "TotalColiforms",        :limit => 10
    t.float   "Ecoli",                 :limit => 15
  end

  add_index "tblbacterialanalysis", ["AquaticActivityID"], :name => "{B0CA8FCD-3C0D-4472-B2A9-904822"
  add_index "tblbacterialanalysis", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblbacterialanalysis", ["BacterialAnalysisID"], :name => "BacterialAnalysisID"
  add_index "tblbacterialanalysis", ["TempAquaticActivityID"], :name => "OldAquaticActivityID"

  create_table "tblbroodstockcollection", :primary_key => "AquaticActivityID", :force => true do |t|
    t.integer "TempAquaticActivityID", :limit => 10
    t.float   "Wild_M_MSW",            :limit => 15
    t.float   "Wild_F_MSW",            :limit => 15
    t.float   "Clipped_M_MSW",         :limit => 15
    t.float   "Clipped_F_MSW",         :limit => 15
    t.float   "Total_M_MSW",           :limit => 15
    t.float   "Total_F_MSW",           :limit => 15
    t.float   "Total_MSW",             :limit => 15
    t.float   "Wild_M_Grilse",         :limit => 15
    t.float   "Wild_F_Grilse",         :limit => 15
    t.float   "Clipped_M_Grilse",      :limit => 15
    t.float   "Clipped_F_Grilse",      :limit => 15
    t.float   "Total_M_Grilse",        :limit => 15
    t.float   "Total_F_Grilse",        :limit => 15
    t.float   "Total_Grilse",          :limit => 15
    t.float   "Total_F_ASalmon",       :limit => 15
    t.float   "Total_M_ASalmon",       :limit => 15
    t.float   "Total_ASalmon",         :limit => 15
    t.string  "Comments",              :limit => 250
  end

  add_index "tblbroodstockcollection", ["AquaticActivityID"], :name => "{980D252C-07FE-480B-9235-EA23BD"
  add_index "tblbroodstockcollection", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblbroodstockcollection", ["AquaticActivityID"], :name => "AquaticActivityID1"

  create_table "tblcrownreserve", :primary_key => "RegulatedWaterID", :force => true do |t|
    t.string  "AnglingFishSpecies", :limit => 20
    t.float   "StreamLength_km",    :limit => 15
    t.integer "NoPools",            :limit => 5
    t.integer "NoDays",             :limit => 5
    t.integer "MaxRodPerDay",       :limit => 5
    t.string  "AccommodationsInd",  :limit => 1
    t.string  "StartYear",          :limit => 10
    t.string  "EndYear",            :limit => 10
    t.string  "ActiveInd",          :limit => 1
  end

  add_index "tblcrownreserve", ["RegulatedWaterID"], :name => "{2F73944A-EE45-4C58-B41D-F6542A"
  add_index "tblcrownreserve", ["RegulatedWaterID"], :name => "RegulatedWatersID"

  create_table "tbldraingeunit", :primary_key => "DrainageCd", :force => true do |t|
    t.string  "Level1No",     :limit => 2
    t.string  "Level1Name",   :limit => 40
    t.string  "Level2No",     :limit => 2
    t.string  "Level2Name",   :limit => 50
    t.string  "Level3No",     :limit => 2
    t.string  "Level3Name",   :limit => 50
    t.string  "Level4No",     :limit => 2
    t.string  "Level4Name",   :limit => 50
    t.string  "Level5No",     :limit => 2
    t.string  "Level5Name",   :limit => 50
    t.string  "Level6No",     :limit => 2
    t.string  "Level6Name",   :limit => 50
    t.string  "UnitName",     :limit => 55
    t.string  "UnitType",     :limit => 4
    t.string  "BorderInd",    :limit => 1
    t.integer "StreamOrder",  :limit => 5
    t.float   "Area_ha",      :limit => 15
    t.float   "Area_percent", :limit => 15
  end

  add_index "tbldraingeunit", ["Level1No"], :name => "{C26A40DF-1604-4BE7-BDBD-F8BC6C"
  add_index "tbldraingeunit", ["DrainageCd"], :name => "tblDraingeUnitsDrainageCd"
  add_index "tbldraingeunit", ["Level1No"], :name => "tblDraingeUnitsLevel1No"

  create_table "tblelectrofishingdata", :primary_key => "EFDataID", :force => true do |t|
    t.float   "oldEFDataID",           :limit => 15
    t.integer "TempDataID",            :limit => 10
    t.integer "AquaticActivityID",     :limit => 10
    t.float   "TempAquaticActivityID", :limit => 15
    t.string  "FishSpeciesCd",         :limit => 2
    t.string  "FishAgeClass",          :limit => 10
    t.string  "RelativeSizeClass",     :limit => 10
    t.float   "AveWeight_gm",          :limit => 15
    t.float   "AveForkLength_cm",      :limit => 15
    t.float   "AveTotalLength_cm",     :limit => 15
    t.float   "Sweep1NoFish",          :limit => 15
    t.float   "Sweep1Time_s",          :limit => 15
    t.float   "Sweep2NoFish",          :limit => 15
    t.float   "Sweep2Time_s",          :limit => 15
    t.float   "Sweep3NoFish",          :limit => 15
    t.float   "Sweep3Time_s",          :limit => 15
    t.float   "Sweep4NoFish",          :limit => 15
    t.float   "Sweep4Time_s",          :limit => 15
    t.float   "Sweep5NoFish",          :limit => 15
    t.float   "Sweep5Time_s",          :limit => 15
    t.float   "Sweep6NoFish",          :limit => 15
    t.float   "Sweep6Time_s",          :limit => 15
    t.integer "TotalNoSweeps",         :limit => 10
    t.float   "TotalNoFish",           :limit => 15
    t.float   "PercentClipped",        :limit => 15
    t.string  "Comments",              :limit => 100
    t.string  "DW_Comments",           :limit => 100
  end

  add_index "tblelectrofishingdata", ["AquaticActivityID"], :name => "{196E57D0-3F38-43B2-B4E7-3A9546"
  add_index "tblelectrofishingdata", ["FishSpeciesCd"], :name => "{3307D7AA-47A2-4D30-B30E-4596D1"
  add_index "tblelectrofishingdata", ["FishAgeClass"], :name => "{D2C885E2-CCEF-47E5-AF27-170490"
  add_index "tblelectrofishingdata", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblelectrofishingdata", ["TempAquaticActivityID"], :name => "EFASSMT_ID"
  add_index "tblelectrofishingdata", ["oldEFDataID"], :name => "EFDATA_ID"
  add_index "tblelectrofishingdata", ["EFDataID"], :name => "EFDataID"
  add_index "tblelectrofishingdata", ["TempDataID"], :name => "TempEFDataID"

  create_table "tblelectrofishingmarkrecapturedata", :primary_key => "EFMRDataID", :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.float   "TempAquaticActivityID", :limit => 15
    t.integer "TempDataID",            :limit => 10
    t.integer "RecaptureTime",         :limit => 5
    t.string  "FishSpeciesCd",         :limit => 2
    t.string  "FishAgeClass",          :limit => 10
    t.float   "AveWeight_gm",          :limit => 15
    t.float   "AveForkLength_cm",      :limit => 15
    t.float   "AveTotalLength_cm",     :limit => 15
    t.float   "MarkCount",             :limit => 15
    t.float   "MarkMarked",            :limit => 15
    t.float   "MarkMorts",             :limit => 15
    t.float   "RecaptureCount",        :limit => 15
    t.float   "RecaptureUnmarked",     :limit => 15
    t.float   "RecaptureMarked",       :limit => 15
    t.float   "RecaptureMorts",        :limit => 15
    t.float   "MarkEfficiency",        :limit => 15
    t.string  "Comments",              :limit => 100
    t.string  "DW_Comments",           :limit => 100
  end

  add_index "tblelectrofishingmarkrecapturedata", ["FishAgeClass"], :name => "{22F2CEBB-F47B-4837-8840-C009FB"
  add_index "tblelectrofishingmarkrecapturedata", ["AquaticActivityID"], :name => "{B2C296E5-A98F-454E-A7A0-2A3DFE"
  add_index "tblelectrofishingmarkrecapturedata", ["FishSpeciesCd"], :name => "{E1056899-F963-4116-855D-6F47EE"
  add_index "tblelectrofishingmarkrecapturedata", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblelectrofishingmarkrecapturedata", ["TempAquaticActivityID"], :name => "EFASSMT_ID"
  add_index "tblelectrofishingmarkrecapturedata", ["EFMRDataID"], :name => "EFDATA_ID"
  add_index "tblelectrofishingmarkrecapturedata", ["TempDataID"], :name => "TempDataID"

  create_table "tblelectrofishingmethoddetail", :primary_key => "AquaticActivityDetailID", :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.string  "Device",                :limit => 20
    t.string  "SiteSetup",             :limit => 6
    t.integer "NoSweeps",              :limit => 5
    t.float   "StreamLength_m",        :limit => 7
    t.float   "Area_m2",               :limit => 7
    t.float   "Voltage",               :limit => 15
    t.float   "Frequency_Hz",          :limit => 15
    t.float   "DutyCycle",             :limit => 15
    t.float   "POWSetting",            :limit => 15
  end

  add_index "tblelectrofishingmethoddetail", ["AquaticActivityID"], :name => "{974003F4-D516-4FAA-9C71-2FC24E"
  add_index "tblelectrofishingmethoddetail", ["AquaticActivityDetailID"], :name => "AquaticActivityDetailsID"
  add_index "tblelectrofishingmethoddetail", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblelectrofishingmethoddetail", ["TempAquaticActivityID"], :name => "AssmtPrgrmID"

  create_table "tblelectrofishingpopulationestimate", :primary_key => "EFPopulationEstimateID", :force => true do |t|
    t.integer "oldEFPopulationEstimateID", :limit => 10
    t.integer "EFDataID",                  :limit => 10
    t.integer "TempDataID",                :limit => 10
    t.float   "oldEFDataID",               :limit => 15
    t.integer "EFMRDataID",                :limit => 10
    t.boolean "EFDataInd",                                :null => false
    t.integer "AquaticActivityID",         :limit => 10
    t.float   "TempAquaticActivityID",     :limit => 15
    t.string  "Formula",                   :limit => 26
    t.string  "FishSpeciesCd",             :limit => 2
    t.string  "FishAgeClass",              :limit => 10
    t.string  "RelativeSizeClass",         :limit => 10
    t.float   "AveForkLength_cm",          :limit => 15
    t.float   "AveWeight_gm",              :limit => 15
    t.string  "PopulationParameter",       :limit => 20
    t.float   "PopulationEstimate",        :limit => 15
    t.boolean "AutoCalculatedInd",                        :null => false
    t.string  "Comments",                  :limit => 100
  end

  add_index "tblelectrofishingpopulationestimate", ["FishAgeClass"], :name => "{3054E6F5-67BE-4433-BA0D-203C0F"
  add_index "tblelectrofishingpopulationestimate", ["AquaticActivityID"], :name => "{619029C0-02D2-4149-BE10-808545"
  add_index "tblelectrofishingpopulationestimate", ["FishSpeciesCd"], :name => "{D6A691C5-AB3C-4A65-9711-F88235"
  add_index "tblelectrofishingpopulationestimate", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblelectrofishingpopulationestimate", ["TempAquaticActivityID"], :name => "EFASSMT_ID"
  add_index "tblelectrofishingpopulationestimate", ["oldEFDataID"], :name => "EFDATA_ID"
  add_index "tblelectrofishingpopulationestimate", ["EFDataID"], :name => "EFDataID"
  add_index "tblelectrofishingpopulationestimate", ["oldEFPopulationEstimateID"], :name => "EFPopulationEstimateID"
  add_index "tblelectrofishingpopulationestimate", ["EFPopulationEstimateID"], :name => "EFPopulationEstimateID1"
  add_index "tblelectrofishingpopulationestimate", ["TempDataID"], :name => "TempEFDataID"

  create_table "tblenvironmentalobservations", :primary_key => "EnvObservationID", :force => true do |t|
    t.integer "AquaticActivityID",         :limit => 10
    t.string  "ObservationGroup",          :limit => 50
    t.string  "Observation",               :limit => 50
    t.string  "ObservationSupp",           :limit => 50
    t.integer "PipeSize_cm",               :limit => 10
    t.boolean "FishPassageObstructionInd",               :null => false
  end

  add_index "tblenvironmentalobservations", ["EnvObservationID"], :name => "EnvObservationID", :unique => true
  add_index "tblenvironmentalobservations", ["AquaticActivityID"], :name => "AquaticActivityID"

  create_table "tblenvironmentalplanning", :primary_key => "EnvPlanningID", :force => true do |t|
    t.integer  "AquaticActivityID",      :limit => 10
    t.string   "IssueCategory",          :limit => 50
    t.string   "Issue",                  :limit => 250
    t.string   "ActionRequired",         :limit => 250
    t.datetime "ActionTargetDate"
    t.integer  "ActionPriority",         :limit => 5
    t.datetime "ActionCompletionDate"
    t.boolean  "FollowUpRequired",                      :null => false
    t.datetime "FollowUpTargetDate"
    t.datetime "FollowUpCompletionDate"
  end

  add_index "tblenvironmentalplanning", ["EnvPlanningID"], :name => "EnvPlanningID", :unique => true
  add_index "tblenvironmentalplanning", ["AquaticActivityID"], :name => "AquaticActivityID"

  create_table "tblenvironmentalsurveyfieldmeasures", :primary_key => "FieldMeasureID", :force => true do |t|
    t.integer "AquaticActivityID", :limit => 10
    t.string  "StreamCover",       :limit => 10
    t.string  "BankStability",     :limit => 20
    t.integer "BankSlope_Rt",      :limit => 5
    t.integer "BankSlope_Lt",      :limit => 5
    t.string  "StreamType",        :limit => 10
    t.string  "StreamTypeSupp",    :limit => 30
    t.boolean "SuspendedSilt",                   :null => false
    t.boolean "EmbeddedSub",                     :null => false
    t.boolean "AquaticPlants",                   :null => false
    t.boolean "Algae",                           :null => false
    t.boolean "Petroleum",                       :null => false
    t.boolean "Odor",                            :null => false
    t.boolean "Foam",                            :null => false
    t.boolean "DeadFish",                        :null => false
    t.boolean "Other",                           :null => false
    t.string  "OtherSupp",         :limit => 50
    t.float   "Length_m",          :limit => 7
    t.float   "AveWidth_m",        :limit => 7
    t.float   "AveDepth_m",        :limit => 7
    t.float   "Velocity_mpers",    :limit => 7
    t.string  "WaterClarity",      :limit => 16
    t.string  "WaterColor",        :limit => 10
    t.string  "Weather_Past",      :limit => 20
    t.string  "Weather_Current",   :limit => 20
    t.integer "RZ_Lawn_Lt",        :limit => 5
    t.float   "RZ_Lawn_Rt",        :limit => 7
    t.integer "RZ_RowCrop_Lt",     :limit => 5
    t.integer "RZ_RowCrop_Rt",     :limit => 5
    t.integer "RZ_ForageCrop_Lt",  :limit => 5
    t.integer "RZ_ForageCrop_Rt",  :limit => 5
    t.integer "RZ_Shrubs_Lt",      :limit => 5
    t.integer "RZ_Shrubs_Rt",      :limit => 5
    t.integer "RZ_Hardwood_Lt",    :limit => 5
    t.integer "RZ_Hardwood_Rt",    :limit => 5
    t.integer "RZ_Softwood_Lt",    :limit => 5
    t.integer "RZ_Softwood_Rt",    :limit => 5
    t.integer "RZ_Mixed_Lt",       :limit => 5
    t.integer "RZ_Mixed_Rt",       :limit => 5
    t.integer "RZ_Meadow_Lt",      :limit => 5
    t.integer "RZ_Meadow_Rt",      :limit => 5
    t.integer "RZ_Wetland_Lt",     :limit => 5
    t.integer "RZ_Wetland_Rt",     :limit => 5
    t.integer "RZ_Altered_Lt",     :limit => 5
    t.integer "RZ_Altered_Rt",     :limit => 5
    t.string  "ST_TimeofDay",      :limit => 5
    t.float   "ST_DissOxygen",     :limit => 7
    t.float   "ST_AirTemp_C",      :limit => 7
    t.float   "ST_WaterTemp_C",    :limit => 7
    t.float   "ST_pH",             :limit => 7
    t.float   "ST_Conductivity",   :limit => 7
    t.float   "ST_Flow_cms",       :limit => 7
    t.string  "ST_DELGFieldNo",    :limit => 50
    t.string  "GW1_TimeofDay",     :limit => 5
    t.float   "GW1_DissOxygen",    :limit => 7
    t.float   "GW1_AirTemp_C",     :limit => 7
    t.float   "GW1_WaterTemp_C",   :limit => 7
    t.float   "GW1_pH",            :limit => 7
    t.float   "GW1_Conductivity",  :limit => 7
    t.float   "GW1_Flow_cms",      :limit => 7
    t.string  "GW1_DELGFieldNo",   :limit => 50
    t.string  "GW2_TimeofDay",     :limit => 5
    t.float   "GW2_DissOxygen",    :limit => 7
    t.float   "GW2_AirTemp_C",     :limit => 7
    t.float   "GW2_WaterTemp_C",   :limit => 7
    t.float   "GW2_pH",            :limit => 7
    t.float   "GW2_Conductivity",  :limit => 7
    t.float   "GW2_Flow_cms",      :limit => 7
    t.string  "GW2_DELGFieldNo",   :limit => 50
  end

  add_index "tblenvironmentalsurveyfieldmeasures", ["FieldMeasureID"], :name => "FieldMeasureID", :unique => true
  add_index "tblenvironmentalsurveyfieldmeasures", ["AquaticActivityID"], :name => "AquaticActivityID"

  create_table "tblfishcount", :primary_key => "FishCountID", :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.string  "MovementDirection",     :limit => 4
    t.string  "MovementTime",          :limit => 10
    t.string  "FishSpeciesCd",         :limit => 3
    t.string  "FishOrigin",            :limit => 10
    t.string  "FishAgeClass",          :limit => 12
    t.string  "RelativeSizeClass",     :limit => 10
    t.string  "FishAge",               :limit => 5
    t.string  "SexCd",                 :limit => 1
    t.integer "NoFish",                :limit => 10
    t.string  "FishStatusCd",          :limit => 4
    t.float   "RPM",                   :limit => 15
    t.string  "RPM Left_Right",        :limit => 16
  end

  add_index "tblfishcount", ["FishSpeciesCd"], :name => "{06EA6C0C-673D-49A5-80FF-3F8553"
  add_index "tblfishcount", ["SexCd"], :name => "{5D7B660D-0861-4E5F-A43C-FEA1F6"
  add_index "tblfishcount", ["AquaticActivityID"], :name => "{66BB9C3A-7285-4FDB-B4BC-DBCB50"
  add_index "tblfishcount", ["FishStatusCd"], :name => "{CAEC13B9-5CC5-4B2A-A167-36394C"
  add_index "tblfishcount", ["FishAgeClass"], :name => "{E12AAD0E-8C73-403B-9564-76C09F"
  add_index "tblfishcount", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblfishcount", ["AquaticActivityID"], :name => "AquaticActivityID1"
  add_index "tblfishcount", ["FishCountID"], :name => "FishCountID"

  create_table "tblfishfacility", :primary_key => "FishFacilityID", :force => true do |t|
    t.integer "AquaticSiteID",        :limit => 10
    t.string  "FishFacilityType",     :limit => 20
    t.string  "FishFacilityCategory", :limit => 20
    t.integer "WaterBodyID",          :limit => 10
    t.string  "FishFacilityName",     :limit => 50
    t.string  "AgencyCd",             :limit => 4
    t.string  "YearsActive",          :limit => 20
    t.string  "ActiveInd",            :limit => 15
  end

  add_index "tblfishfacility", ["AgencyCd"], :name => "{62AE88DB-B6DA-461A-8EFD-79994C"
  add_index "tblfishfacility", ["AquaticSiteID"], :name => "AquaticSiteID"
  add_index "tblfishfacility", ["FishFacilityID"], :name => "FishFacilityID"
  add_index "tblfishfacility", ["WaterBodyID"], :name => "WaterBodyID"

  create_table "tblfishmating", :primary_key => "FishMatingID", :force => true do |t|
    t.string "FishMating", :limit => 150
  end

  add_index "tblfishmating", ["FishMatingID"], :name => "Mating Code"

  create_table "tblfishmeasurement", :primary_key => "FishSampleID", :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.integer "SweepNo",               :limit => 10
    t.string  "FishSpeciesCd",         :limit => 2
    t.string  "FishOrigin",            :limit => 1
    t.string  "FishAge"
    t.string  "FishAgeClass",          :limit => 20
    t.string  "RelativeSizeClass",     :limit => 6
    t.string  "SexCd",                 :limit => 4
    t.string  "Maturity",              :limit => 50
    t.string  "FishStatusCd",          :limit => 25
    t.integer "FishMortalityCauseCd",  :limit => 10
    t.float   "ForkLength_mm",         :limit => 15
    t.float   "TotalLength_mm",        :limit => 15
    t.float   "Weight_gm",             :limit => 15
    t.integer "ObservedMarkCd",        :limit => 10
    t.string  "ObservedTagTypeCd"
    t.string  "ObservedTagNo"
    t.integer "AppliedMarkCd",         :limit => 10
    t.string  "AppliedTagTypeCd"
    t.string  "AppliedTagDetails",     :limit => 50
    t.string  "AppliedTagNo"
    t.string  "ScaleSampleInd",        :limit => 1
    t.string  "KFactor"
    t.string  "Comments"
  end

  add_index "tblfishmeasurement", ["FishAgeClass"], :name => "{3A73ACBD-5E01-4161-A005-936056"
  add_index "tblfishmeasurement", ["ObservedMarkCd"], :name => "{5789DFE0-E15C-4411-B206-AB85F6"
  add_index "tblfishmeasurement", ["FishStatusCd"], :name => "{78BF6931-900B-4BA0-9668-0F6ADF"
  add_index "tblfishmeasurement", ["FishMortalityCauseCd"], :name => "{B3899285-6946-4B56-8F15-8CC930"
  add_index "tblfishmeasurement", ["AppliedMarkCd"], :name => "{BAEC7ACC-1DA9-47D4-A524-136D1F"
  add_index "tblfishmeasurement", ["FishSpeciesCd"], :name => "{C8F34BD0-92BF-465C-9970-616E6A"
  add_index "tblfishmeasurement", ["SexCd"], :name => "{F065211C-F778-44FD-9014-6CD26F"
  add_index "tblfishmeasurement", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblfishmeasurement", ["AquaticActivityID"], :name => "AquaticActivityID1"

  create_table "tblfishmeasurement2", :primary_key => "FishSampleID", :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "OLDAquaticActivityID",  :limit => 10
    t.integer "SweepNo",               :limit => 10
    t.string  "FishSpeciesCd",         :limit => 2
    t.string  "FishOrigin",            :limit => 1
    t.string  "FishAgeClass",          :limit => 20
    t.string  "FishAge"
    t.string  "RelativeSizeClass",     :limit => 6
    t.string  "SexCd",                 :limit => 4
    t.string  "MaturityCd",            :limit => 10
    t.string  "FishStatusCd",          :limit => 25
    t.string  "FishMortalityCauseCds", :limit => 50
    t.float   "ForkLength_mm",         :limit => 15
    t.float   "TotalLength_cm",        :limit => 15
    t.float   "Weight_gm",             :limit => 15
    t.string  "ObservedMarkCd",        :limit => 2
    t.string  "ObservedTagTypeCd"
    t.string  "ObservedTagNo"
    t.string  "AppliedMarkCd",         :limit => 2
    t.string  "AppliedTagTypeCd"
    t.string  "AppliedTagNo"
    t.string  "ScaleSampleInd",        :limit => 1
    t.string  "KFactor"
    t.string  "Comments"
  end

  add_index "tblfishmeasurement2", ["AquaticActivityID"], :name => "{0E232033-A5BB-4B4F-BA06-DD7062"
  add_index "tblfishmeasurement2", ["FishStatusCd"], :name => "{1FB6F113-EDE9-42D8-A821-84AFB8"
  add_index "tblfishmeasurement2", ["FishAgeClass"], :name => "{7D284B90-A07C-423D-AA9F-8B7203"
  add_index "tblfishmeasurement2", ["FishSpeciesCd"], :name => "{9BC5A98D-87A3-4248-9422-083EA1"
  add_index "tblfishmeasurement2", ["SexCd"], :name => "{A22C587D-E653-4BFB-B943-F54372"
  add_index "tblfishmeasurement2", ["OLDAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblfishmeasurement2", ["AquaticActivityID"], :name => "AquaticActivityID1"

  create_table "tblfishstock", :primary_key => "FishStockID", :force => true do |t|
    t.string  "FishSpeciesCd",  :limit => 2
    t.integer "WaterBodyID",    :limit => 10
    t.string  "FishStockName",  :limit => 150
    t.string  "WildStatus",     :limit => 30
    t.string  "RunSeason",      :limit => 10
    t.boolean "TriploidInd",                   :null => false
    t.boolean "LandlockedInd",                 :null => false
    t.integer "FishFacilityID", :limit => 10
  end

  add_index "tblfishstock", ["FishSpeciesCd"], :name => "{9CC37BEE-D922-4454-8E9C-90F6EB"
  add_index "tblfishstock", ["FishFacilityID"], :name => "FishFacilityID"
  add_index "tblfishstock", ["FishStockID"], :name => "FishStockID"
  add_index "tblfishstock", ["WaterBodyID"], :name => "WaterBodyID"

  create_table "tblfishtranslocation", :primary_key => "FishTranslocationID", :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.integer "FishStockID",           :limit => 10
    t.string  "FishAgeClass",          :limit => 6
    t.float   "NoFish",                :limit => 15
    t.float   "ForkLength_cm",         :limit => 15
    t.float   "Weight_gm",             :limit => 15
    t.integer "AppliedMarkCd",         :limit => 10
    t.string  "AppliedTagNo",          :limit => 50
    t.string  "Source",                :limit => 50
  end

  add_index "tblfishtranslocation", ["FishAgeClass"], :name => "{197AEA6C-6EDA-4CDD-928E-AC3D74"
  add_index "tblfishtranslocation", ["FishStockID"], :name => "{3F66498F-954D-4260-B4DB-340DA6"
  add_index "tblfishtranslocation", ["AppliedMarkCd"], :name => "{C1A7EB34-A8A5-481B-A17D-074E4F"
  add_index "tblfishtranslocation", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblfishtranslocation", ["FishStockID"], :name => "FishStockID"
  add_index "tblfishtranslocation", ["FishTranslocationID"], :name => "FishTranslocationID"
  add_index "tblfishtranslocation", ["TempAquaticActivityID"], :name => "OldAquaticActivityID"

  create_table "tblhabitatrestoration", :primary_key => "AquaticActivityID", :force => true do |t|
    t.integer "TempAquaticActivityID", :limit => 10
    t.string  "RestorationDesc",       :limit => 150
  end

  add_index "tblhabitatrestoration", ["AquaticActivityID"], :name => "{A405B266-7050-4183-B60D-3AFE5A"
  add_index "tblhabitatrestoration", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblhabitatrestoration", ["TempAquaticActivityID"], :name => "OldAquaticActivityID"

  create_table "tblhabitatunit", :primary_key => "HabitatUnitID", :force => true do |t|
    t.integer "AquaticActivityID",         :limit => 10
    t.integer "TempAquaticActivityID",     :limit => 10
    t.integer "RiverSystemID",             :limit => 5
    t.float   "WaterBodyID",               :limit => 15
    t.string  "WaterBodyName",             :limit => 40
    t.float   "StartRouteMeas",            :limit => 15
    t.float   "EndRouteMeas",              :limit => 15
    t.float   "CalibratedLength_m",        :limit => 15
    t.integer "StreamOrder",               :limit => 5
    t.integer "ReachNo",                   :limit => 5
    t.string  "HabitatUnitNo",             :limit => 3
    t.string  "StreamTypeCd",              :limit => 2
    t.string  "ChannelCd",                 :limit => 1
    t.string  "ChannelPosition",           :limit => 1
    t.float   "StreamLength_m",            :limit => 15
    t.float   "WetWidth_m",                :limit => 15
    t.float   "BankFullWidth_m",           :limit => 15
    t.float   "Area_m2",                   :limit => 15
    t.integer "Bedrock",                   :limit => 5
    t.integer "Boulder",                   :limit => 5
    t.integer "Rock",                      :limit => 5
    t.integer "Rubble",                    :limit => 5
    t.integer "Gravel",                    :limit => 5
    t.integer "Sand",                      :limit => 5
    t.integer "Fines",                     :limit => 5
    t.integer "TotalLgSubstrate",          :limit => 5
    t.integer "AveDepth_cm",               :limit => 5
    t.integer "UndercutBank_L",            :limit => 5
    t.integer "UndercutBank_R",            :limit => 5
    t.integer "OverhangingVeg_L",          :limit => 5
    t.integer "OverhangingVeg_R",          :limit => 5
    t.float   "WoodyDebrisLength_m",       :limit => 15
    t.float   "WoodyDebrisLengthPer100m2", :limit => 15
    t.string  "WaterSourceCd",             :limit => 1
    t.float   "WaterFlow_cms",             :limit => 15
    t.string  "AssmtTime",                 :limit => 5
    t.float   "WaterTemp_C",               :limit => 15
    t.float   "AirTemp_C",                 :limit => 15
    t.string  "EmbeddedCd",                :limit => 1
    t.string  "CommentCds",                :limit => 150
    t.integer "Shade",                     :limit => 5
    t.integer "Bank_Bare",                 :limit => 5
    t.integer "Bank_Grass",                :limit => 5
    t.integer "Bank_Shrubs",               :limit => 5
    t.integer "Bank_Trees",                :limit => 5
    t.integer "Bank_L_Stable",             :limit => 5
    t.integer "Bank_L_BarelyStable",       :limit => 5
    t.integer "Bank_L_Eroding",            :limit => 5
    t.integer "Bank_R_Stable",             :limit => 5
    t.integer "Bank_R_BarelyStable",       :limit => 5
    t.integer "Bank_R_Eroding",            :limit => 5
    t.string  "FieldNotes",                :limit => 250
  end

  add_index "tblhabitatunit", ["ChannelCd"], :name => "{2C20CD7A-D76A-4B79-9722-A2169A"
  add_index "tblhabitatunit", ["EmbeddedCd"], :name => "{4E89055D-2136-4D66-B94B-190547"
  add_index "tblhabitatunit", ["StreamTypeCd"], :name => "{77627C39-5B81-431D-8AFC-2A560E"
  add_index "tblhabitatunit", ["AquaticActivityID"], :name => "{AFB36345-F8C9-44B0-87E6-4C519B"
  add_index "tblhabitatunit", ["WaterSourceCd"], :name => "{B40FC300-BC5B-4B37-B35E-421B87"
  add_index "tblhabitatunit", ["RiverSystemID"], :name => "{F8305F71-FA7B-4614-BD08-B115EB"
  add_index "tblhabitatunit", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblhabitatunit", ["AquaticActivityID"], :name => "AquaticActivityID1"
  add_index "tblhabitatunit", ["HabitatUnitID"], :name => "HABUNIT_ID"
  add_index "tblhabitatunit", ["RiverSystemID"], :name => "RiverSystemID"
  add_index "tblhabitatunit", ["WaterBodyID"], :name => "WATER_ID"

  create_table "tblhabitatunitcomment", :id => false, :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.float   "HabitatUnitID",         :limit => 15
    t.string  "CommentCd",             :limit => 3
    t.string  "Comment",               :limit => 30
  end

  add_index "tblhabitatunitcomment", ["HabitatUnitID"], :name => "{1D8D4C80-ED60-4F4D-AD66-AEFD1A"
  add_index "tblhabitatunitcomment", ["CommentCd"], :name => "{CE25D1D9-753C-4839-A68F-C3A029"
  add_index "tblhabitatunitcomment", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblhabitatunitcomment", ["AquaticActivityID"], :name => "AquaticActivityID1"
  add_index "tblhabitatunitcomment", ["HabitatUnitID"], :name => "HABUNIT_ID"

  create_table "tblhabitatunitwatermeasurement", :id => false, :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.float   "HabitatUnitID",         :limit => 15
    t.string  "WaterSourceCd",         :limit => 1
    t.string  "AssmtTime",             :limit => 5
    t.float   "WaterTemp_C",           :limit => 15
    t.float   "AirTemp_C",             :limit => 15
    t.float   "WaterFlow_cms",         :limit => 15
    t.float   "WaterFlow_gpm",         :limit => 15
    t.float   "WaterFlow_lpm",         :limit => 15
  end

  add_index "tblhabitatunitwatermeasurement", ["HabitatUnitID"], :name => "{597706DE-D7FA-4CD5-A07A-B86693"
  add_index "tblhabitatunitwatermeasurement", ["WaterSourceCd"], :name => "{930FC3B8-C2A8-4C09-B400-AED987"
  add_index "tblhabitatunitwatermeasurement", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblhabitatunitwatermeasurement", ["AquaticActivityID"], :name => "AquaticActivityID1"
  add_index "tblhabitatunitwatermeasurement", ["HabitatUnitID"], :name => "HABUNIT_ID"

  create_table "tbllakeattribute", :primary_key => "WaterBodyID", :force => true do |t|
    t.string  "County",                   :limit => 20
    t.string  "Parish",                   :limit => 30
    t.string  "LakeClass",                :limit => 15
    t.float   "Area_m2",                  :limit => 15
    t.float   "Perimeter_m",              :limit => 15
    t.integer "ShorelineCrown_Percent",   :limit => 10
    t.integer "ShorelinePrivate_Percent", :limit => 10
    t.float   "Depth_Max",                :limit => 15
    t.float   "Depth_Mean",               :limit => 15
    t.integer "Depth_Percent_LT6m",       :limit => 5
    t.integer "Depth_Percent_LT3m",       :limit => 5
    t.string  "StratifiedInd",            :limit => 2
    t.float   "Volume_m3",                :limit => 15
    t.float   "AcreFeet",                 :limit => 15
    t.float   "MEI",                      :limit => 15
    t.float   "PotentialProductivity",    :limit => 15
    t.float   "WCHIndex",                 :limit => 15
    t.float   "SalmonIndex",              :limit => 15
    t.float   "TogueIndex",               :limit => 15
    t.float   "TotalProductivity",        :limit => 15
    t.float   "ShorelineDev",             :limit => 15
  end

  add_index "tbllakeattribute", ["WaterBodyID"], :name => "{4E408586-E3BB-430C-BCE6-FAB4A7", :unique => true
  add_index "tbllakeattribute", ["WaterBodyID"], :name => "WATER_ID"

  create_table "tbllakesurveydetail", :id => false, :force => true do |t|
    t.integer "AquaticActivityID",       :limit => 10
    t.integer "TempAquaticActivityID",   :limit => 10
    t.string  "DNRRegion",               :limit => 1
    t.string  "CountyCd",                :limit => 2
    t.string  "County",                  :limit => 20
    t.string  "ParishCd",                :limit => 3
    t.string  "PARISH",                  :limit => 30
    t.integer "AirTemp_F",               :limit => 5
    t.integer "Terrain_Flat",            :limit => 5
    t.integer "Terrain_Rolling",         :limit => 5
    t.integer "Terrain_Hilly",           :limit => 5
    t.integer "Terrain_Mountains",       :limit => 5
    t.integer "Forest_Softwood",         :limit => 5
    t.integer "Forest_Hardwood",         :limit => 5
    t.integer "Forest_Soft_Hard",        :limit => 5
    t.integer "Forest_Hard_Soft",        :limit => 5
    t.integer "ShoreUse_Cutover",        :limit => 5
    t.integer "ShoreUse_MatureTimber",   :limit => 5
    t.integer "ShoreUse_ImmatureTimber", :limit => 5
    t.integer "ShoreUse_Residences",     :limit => 5
    t.integer "ShoreUse_Cottages",       :limit => 5
    t.integer "ShoreUse_Farms",          :limit => 5
    t.integer "ShoreUse_Wetlands",       :limit => 5
    t.integer "AquaticVeg_Submerged",    :limit => 5
    t.integer "AquaticVeg_Emergent",     :limit => 5
    t.integer "ShoreVeg_Sedge",          :limit => 5
    t.integer "ShoreVeg_Heath",          :limit => 5
    t.integer "ShoreVeg_Cedar",          :limit => 5
    t.integer "ShoreVeg_Alder",          :limit => 5
    t.integer "Substrate_Mud",           :limit => 5
    t.integer "Substrate_Sand",          :limit => 5
    t.integer "Substrate_Rubble",        :limit => 5
    t.integer "Substrate_Gravel",        :limit => 5
    t.integer "Substrate_Rock",          :limit => 5
    t.integer "Substrate_Boulders",      :limit => 5
    t.integer "Substrate_Bedrock",       :limit => 5
    t.integer "PublicAccess_Trail",      :limit => 5
    t.integer "PublicAccess_Car",        :limit => 5
    t.integer "PublicAccess_Jeep",       :limit => 5
    t.integer "PublicAccess_Boat",       :limit => 5
    t.integer "PrivateAccess_Trail",     :limit => 5
    t.integer "PrivateAccess_Car",       :limit => 5
    t.integer "PrivateAccess_Jeep",      :limit => 5
    t.integer "PrivateAccess_Boat",      :limit => 5
    t.integer "NoBoatLandings",          :limit => 5
    t.integer "ShoreOwnership_Crown",    :limit => 5
    t.integer "ShoreOwnership_Private",  :limit => 5
    t.integer "NoCamps",                 :limit => 5
    t.integer "NoBeaches",               :limit => 5
    t.string  "WoodyDebris",             :limit => 14
    t.string  "ShorelineShape",          :limit => 16
    t.string  "SpawningPotential",       :limit => 4
    t.integer "SecchiDepth_ft",          :limit => 5
    t.string  "WaterColor",              :limit => 14
    t.string  "WaterChemInd",            :limit => 1
    t.string  "AnglingInfoInd",          :limit => 1
  end

  add_index "tbllakesurveydetail", ["AquaticActivityID"], :name => "{5316EF9C-8A04-4E5D-9CB5-393792"
  add_index "tbllakesurveydetail", ["AquaticActivityID"], :name => "ActivityID"
  add_index "tbllakesurveydetail", ["TempAquaticActivityID"], :name => "oldAquaticActivityID"

  create_table "tbllakesurveyfishspecies", :primary_key => "LakeSurveyFishID", :force => true do |t|
    t.integer "AquaticActivityID", :limit => 10
    t.integer "OldAssmtID",        :limit => 5
    t.integer "HoursFished",       :limit => 5
    t.string  "GearType",          :limit => 20
    t.string  "FishSpeciesCd",     :limit => 2
    t.integer "NoFish",            :limit => 5
    t.float   "Length_Min",        :limit => 15
    t.float   "Length_Max",        :limit => 15
    t.string  "PopulationStatus",  :limit => 8
  end

  add_index "tbllakesurveyfishspecies", ["AquaticActivityID"], :name => "{83C4C015-3FED-4A6C-A4CA-11E735"
  add_index "tbllakesurveyfishspecies", ["FishSpeciesCd"], :name => "{AC5B557E-7BBC-48AF-A07C-926CB9"
  add_index "tbllakesurveyfishspecies", ["AquaticActivityID"], :name => "activityid"
  add_index "tbllakesurveyfishspecies", ["OldAssmtID"], :name => "ASSMT_ID"
  add_index "tbllakesurveyfishspecies", ["LakeSurveyFishID"], :name => "LakeSurveyFishID"

  create_table "tbllakesurveytribassessment", :primary_key => "LakeSurveyTribID", :force => true do |t|
    t.integer "AquaticActivityID",  :limit => 10
    t.integer "OldAssmtID",         :limit => 5
    t.string  "TributaryName",      :limit => 20
    t.float   "SurveyLength_mi",    :limit => 15
    t.integer "AveWidth_ft",        :limit => 5
    t.string  "WaterLevel",         :limit => 8
    t.integer "Silt",               :limit => 5
    t.integer "Sand",               :limit => 5
    t.integer "Gravel",             :limit => 5
    t.integer "Rubble",             :limit => 5
    t.integer "Rock",               :limit => 5
    t.integer "Boulder",            :limit => 5
    t.integer "Bedrock",            :limit => 5
    t.integer "NurseryLength_ft",   :limit => 5
    t.integer "NurseryWidth_ft",    :limit => 5
    t.integer "NurseryQuality",     :limit => 5
    t.integer "SpawningLength_ft",  :limit => 5
    t.integer "SpawningWidth_ft",   :limit => 5
    t.integer "SpawningQuality",    :limit => 5
    t.integer "NoPools_LT3ftDeep",  :limit => 5
    t.integer "NoPools_3to6ftDeep", :limit => 5
    t.integer "NoPools_GT6ftDeep",  :limit => 5
    t.string  "ObstructionInd",     :limit => 1
    t.string  "ObstructionType",    :limit => 10
    t.string  "FishwayInd",         :limit => 1
    t.integer "VerticalJump",       :limit => 5
    t.integer "HorizontalJump",     :limit => 5
  end

  add_index "tbllakesurveytribassessment", ["AquaticActivityID"], :name => "{815C93E0-C509-47BE-939F-B306D3"
  add_index "tbllakesurveytribassessment", ["AquaticActivityID"], :name => "activityID"
  add_index "tbllakesurveytribassessment", ["OldAssmtID"], :name => "ASSMT_ID"
  add_index "tbllakesurveytribassessment", ["LakeSurveyTribID"], :name => "LakeSurveyTribID"

  create_table "tbllakesurveywatermeasurement", :primary_key => "LakeSurveyWaterMeasID", :force => true do |t|
    t.integer "AquaticActivityID",      :limit => 10
    t.integer "OldAssmtID",             :limit => 5
    t.integer "AirTemp",                :limit => 5
    t.float   "SampleDepth",            :limit => 15
    t.integer "WaterTemp_F",            :limit => 5
    t.float   "DissolvedO2",            :limit => 15
    t.float   "O2Saturation",           :limit => 15
    t.float   "pH",                     :limit => 15
    t.float   "PhenoAlkalinity",        :limit => 15
    t.float   "MethylOrangeAlkalinity", :limit => 15
    t.float   "TotalHardness",          :limit => 15
    t.float   "CO2",                    :limit => 15
    t.float   "FreeAcid",               :limit => 15
  end

  add_index "tbllakesurveywatermeasurement", ["AquaticActivityID"], :name => "{FCA583A3-894E-448B-8E19-1E2110"
  add_index "tbllakesurveywatermeasurement", ["AquaticActivityID"], :name => "ACTIVITYID"
  add_index "tbllakesurveywatermeasurement", ["OldAssmtID"], :name => "ASSMT_ID"
  add_index "tbllakesurveywatermeasurement", ["FreeAcid"], :name => "FREE_ACID"
  add_index "tbllakesurveywatermeasurement", ["LakeSurveyWaterMeasID"], :name => "LakeSurveyWaterMeasID"

  create_table "tbllevel1basin", :primary_key => "Level1No", :force => true do |t|
    t.string "Level1Name",   :limit => 40
    t.string "OceanName",    :limit => 20
    t.float  "Area_km2",     :limit => 15
    t.float  "Area_Percent", :limit => 15
  end

  create_table "tblobservations", :primary_key => "ObservationID", :force => true do |t|
    t.integer "AquaticActivityID",         :limit => 10
    t.integer "OandMCd",                   :limit => 10
    t.string  "OandM_Other",               :limit => 50
    t.integer "OandMValuesCd",             :limit => 10
    t.integer "PipeSize_cm",               :limit => 10
    t.boolean "FishPassageObstructionInd",               :null => false
  end

  add_index "tblobservations", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblobservations", ["ObservationID"], :name => "EnvSurveyID"

  create_table "tbloldhabitatsurvey", :primary_key => "HabitatSurveyID", :force => true do |t|
    t.float   "WaterBodyID",          :limit => 15
    t.string  "AgencyCd",             :limit => 4
    t.integer "SectionNo",            :limit => 5
    t.string  "SectionDesc",          :limit => 50
    t.float   "StreamLength_m",       :limit => 15
    t.float   "AveWidth_m",           :limit => 15
    t.float   "Area_m2",              :limit => 15
    t.float   "ProductiveArea",       :limit => 15
    t.float   "NonProductiveArea_m2", :limit => 15
    t.float   "GoodArea_m2",          :limit => 15
    t.float   "FairArea_m2",          :limit => 15
    t.float   "PoorArea_m2",          :limit => 15
    t.string  "FieldNotes",           :limit => 150
  end

  add_index "tbloldhabitatsurvey", ["HabitatSurveyID"], :name => "HabitatSurveyID"
  add_index "tbloldhabitatsurvey", ["WaterBodyID"], :name => "WATER_ID"

  create_table "tblphotos", :primary_key => "PhotoID", :force => true do |t|
    t.integer "AquaticActivityID", :limit => 10
    t.string  "Path",              :limit => 50
    t.string  "FileName",          :limit => 50
  end

  add_index "tblphotos", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblphotos", ["PhotoID"], :name => "PhotoID"

  create_table "tblreconnaissanceresult", :primary_key => "AquaticActivityID", :force => true do |t|
    t.integer "TempAquaticActivityID", :limit => 10
    t.string  "StreamTypeCd",          :limit => 2
    t.float   "WetWidth_m",            :limit => 15
    t.float   "BankFullWidth_m",       :limit => 15
    t.integer "Bedrock",               :limit => 5
    t.integer "Boulder",               :limit => 5
    t.integer "Rock",                  :limit => 5
    t.integer "Rubble",                :limit => 5
    t.integer "Gravel",                :limit => 5
    t.integer "Sand",                  :limit => 5
    t.integer "Fines",                 :limit => 5
    t.string  "EmbeddedCd",            :limit => 1
    t.string  "AssmtTime",             :limit => 4
    t.float   "AirTemp_C",             :limit => 15
    t.float   "WaterTemp_C",           :limit => 15
    t.float   "WaterFlow_cms",         :limit => 15
  end

  add_index "tblreconnaissanceresult", ["StreamTypeCd"], :name => "{A1DC03BD-AD41-48A5-BE14-D25FF1"
  add_index "tblreconnaissanceresult", ["EmbeddedCd"], :name => "{D8682845-4751-4B5D-BC5F-C5F964"
  add_index "tblreconnaissanceresult", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblreconnaissanceresult", ["TempAquaticActivityID"], :name => "oldAquaticActivityID"

  create_table "tblreddcount", :primary_key => "AquaticActivityID", :force => true do |t|
    t.integer "TempAquaticActivityID", :limit => 10
    t.float   "NoSmallRedds",          :limit => 15
    t.float   "NoLargeRedds",          :limit => 15
    t.float   "TotalRedds",            :limit => 15
    t.float   "NoGrilse",              :limit => 15
    t.float   "NoMSW",                 :limit => 15
    t.float   "TotalASalmon",          :limit => 15
    t.string  "Comments",              :limit => 150
  end

  add_index "tblreddcount", ["AquaticActivityID"], :name => "{222C0077-C2AF-4260-A81C-E9A777"
  add_index "tblreddcount", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblreddcount", ["AquaticActivityID"], :name => "AquaticActivityID1"

  create_table "tblregulatedwater", :primary_key => "RegulatedWaterID", :force => true do |t|
    t.integer "WaterBodyID",            :limit => 10
    t.string  "WaterBodyName",          :limit => 50
    t.string  "RegulatedWaterName",     :limit => 50
    t.string  "RegulationType",         :limit => 20
    t.string  "RegulatedWaterCategory", :limit => 20
    t.string  "RegulatedWaterType",     :limit => 20
    t.string  "SectionDes"
    t.string  "IncludesTribuaryInd",    :limit => 1
    t.string  "StartDate",              :limit => 10
    t.string  "EndDate",                :limit => 10
    t.string  "StartDate2",             :limit => 10
    t.string  "EndDate2",               :limit => 10
    t.string  "StartYear",              :limit => 10
    t.string  "EndYear",                :limit => 10
    t.string  "ActiveInd",              :limit => 1
    t.string  "Robin's Comments",       :limit => 250
  end

  add_index "tblregulatedwater", ["RegulatedWaterID"], :name => "ID"
  add_index "tblregulatedwater", ["WaterBodyID"], :name => "WaterBodyID"

  create_table "tblregulatedwaterstretch", :primary_key => "RegWaterStretchID", :force => true do |t|
    t.integer "RegulatedWaterID",       :limit => 10
    t.string  "RegulatedWaterName",     :limit => 50
    t.string  "RegulationType",         :limit => 20
    t.string  "RegulatedWaterCategory", :limit => 20
    t.string  "RegulatedWaterType",     :limit => 20
    t.string  "SectionDesc"
    t.integer "WaterBodyID",            :limit => 10
    t.float   "StartRouteMeas",         :limit => 15
    t.float   "EndRouteMeas",           :limit => 15
    t.float   "StreamLength_m",         :limit => 15
  end

  add_index "tblregulatedwaterstretch", ["WaterBodyID"], :name => "{A1CB7636-57E5-40DC-994A-E5480B"
  add_index "tblregulatedwaterstretch", ["RegulatedWaterID"], :name => "{C115ED9E-8DC5-4E4E-9FD3-028E51"
  add_index "tblregulatedwaterstretch", ["RegWaterStretchID"], :name => "ID"
  add_index "tblregulatedwaterstretch", ["RegulatedWaterID"], :name => "RegWaterID"
  add_index "tblregulatedwaterstretch", ["WaterBodyID"], :name => "WaterBodyID"

  create_table "tblrelatedaquaticactivities", :primary_key => "RelatedAquaticActivitiesID", :force => true do |t|
    t.integer "PrimaryAquaticActivityID",    :limit => 10
    t.integer "RelatedAquaticActivityID",    :limit => 10
    t.integer "oldPrimaryAquaticActivityID", :limit => 10
    t.integer "oldRelatedAquaticActivityID", :limit => 10
  end

  add_index "tblrelatedaquaticactivities", ["oldPrimaryAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblrelatedaquaticactivities", ["oldRelatedAquaticActivityID"], :name => "oldRelatedAquaticActivityID"
  add_index "tblrelatedaquaticactivities", ["PrimaryAquaticActivityID"], :name => "PrimaryAquaticActivityID"
  add_index "tblrelatedaquaticactivities", ["RelatedAquaticActivitiesID"], :name => "RelatedAquaticActivityID"
  add_index "tblrelatedaquaticactivities", ["RelatedAquaticActivityID"], :name => "RelatedAquaticActivityID1"

  create_table "tblriversystem", :primary_key => "RiverSystemID", :force => true do |t|
    t.integer "WaterBodyID",     :limit => 10
    t.string  "RiverSystemName", :limit => 40
    t.string  "DrainageCd",      :limit => 17
  end

  add_index "tblriversystem", ["RiverSystemID"], :name => "RiverSystemID"
  add_index "tblriversystem", ["WaterBodyID"], :name => "WATER_ID"

  create_table "tblsatelliterearing", :primary_key => "AquaticActivityID", :force => true do |t|
    t.integer "TempAquaticActivityID", :limit => 10
    t.integer "NoTanks",               :limit => 5
    t.string  "AgeClassReceived",      :limit => 15
    t.integer "NoReceived",            :limit => 10
    t.string  "DateStocked",           :limit => 10
    t.integer "NoStocked",             :limit => 10
  end

  add_index "tblsatelliterearing", ["AquaticActivityID"], :name => "{63E3F53B-740C-4E97-82E7-710E46"
  add_index "tblsatelliterearing", ["AgeClassReceived"], :name => "{B2F6C32C-EB8E-47D5-ABD1-9D0EB5"
  add_index "tblsatelliterearing", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblsatelliterearing", ["AquaticActivityID"], :name => "AquaticActivityID1"

  create_table "tblsitemeasurement", :primary_key => "SiteMeasurementID", :force => true do |t|
    t.integer "AquaticActivityID", :limit => 10
    t.integer "OandMCd",           :limit => 10
    t.string  "OandM_Other",       :limit => 20
    t.string  "Bank",              :limit => 10
    t.integer "InstrumentCd",      :limit => 10
    t.float   "Measurement",       :limit => 15
    t.integer "UnitofMeasureCd",   :limit => 10
  end

  add_index "tblsitemeasurement", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblsitemeasurement", ["InstrumentCd"], :name => "cdInstrumenttblSiteMeasurement"
  add_index "tblsitemeasurement", ["OandMCd"], :name => "cdOandMtblSiteMeasurement"
  add_index "tblsitemeasurement", ["UnitofMeasureCd"], :name => "cdUnitofMeasuretblSiteMeasureme"
  add_index "tblsitemeasurement", ["SiteMeasurementID"], :name => "SiteMeasurementID"

  create_table "tblspawners", :id => false, :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.float   "SmallRedds",            :limit => 15
    t.float   "LargeRedds",            :limit => 15
    t.float   "TotalRedds",            :limit => 15
    t.float   "NoGrilse",              :limit => 15
    t.float   "NoMSW",                 :limit => 15
    t.float   "TotalASalmon",          :limit => 15
    t.string  "Comments",              :limit => 150
  end

  add_index "tblspawners", ["TempAquaticActivityID"], :name => "AquaticActivityID1"
  add_index "tblspawners", ["AquaticActivityID"], :name => "AquaticActivityID2"

  create_table "tblsportfishinganglinglease", :primary_key => "SportfishingID", :force => true do |t|
    t.integer "RegulatedWaterID",  :limit => 10
    t.integer "LeaseNo",           :limit => 5
    t.string  "Year",              :limit => 4
    t.float   "TB_TS_RodDay",      :limit => 15
    t.integer "TB_TS_RodHours",    :limit => 10
    t.float   "TB_Gr_Harvest",     :limit => 15
    t.float   "TB_Gr_Release",     :limit => 15
    t.float   "TB_Gr_Total",       :limit => 15
    t.float   "TB_MSW_Harvest",    :limit => 15
    t.float   "TB_MSW_Release",    :limit => 15
    t.float   "TB_MSW_Total",      :limit => 15
    t.float   "TB_AS_Harvest",     :limit => 15
    t.float   "TB_AS_Release",     :limit => 15
    t.float   "TB_AS_Total",       :limit => 15
    t.float   "TB_CPU_Grilse",     :limit => 15
    t.float   "TB_CPU_MSW",        :limit => 15
    t.float   "TB_CPU_Total",      :limit => 15
    t.float   "TS_BT_RodDay",      :limit => 15
    t.float   "TS_BT_Harvest",     :limit => 15
    t.float   "TS_BT_Release",     :limit => 15
    t.float   "TS_BT_Total",       :limit => 15
    t.float   "TS_CPU_BrookTrout", :limit => 15
  end

  add_index "tblsportfishinganglinglease", ["RegulatedWaterID"], :name => "{30865C15-4322-4026-86DB-C859C8"
  add_index "tblsportfishinganglinglease", ["LeaseNo"], :name => "LEASE_ID"
  add_index "tblsportfishinganglinglease", ["RegulatedWaterID"], :name => "RegulatedWaterID"

  create_table "tblsportfishingatlanticsalmon", :primary_key => "SportfishingID", :force => true do |t|
    t.integer "WaterBodyID",    :limit => 10
    t.string  "WaterBodyName",  :limit => 55
    t.string  "DrainageCd",     :limit => 17
    t.string  "Year",           :limit => 4
    t.float   "KT_AS_RodDay",   :limit => 15
    t.float   "KT_Gr_Harvest",  :limit => 15
    t.float   "KT_Gr_Release",  :limit => 15
    t.float   "KT_Gr_Total",    :limit => 15
    t.float   "KT_MSW_Harvest", :limit => 15
    t.float   "KT_MSW_Release", :limit => 15
    t.float   "KT_MSW_Total",   :limit => 15
    t.float   "KT_AS_Harvest",  :limit => 15
    t.float   "KT_AS_Release",  :limit => 15
    t.float   "KT_AS_Total",    :limit => 15
    t.float   "KT_CPU_Grilse",  :limit => 15
    t.float   "KT_CPU_MSW",     :limit => 15
    t.float   "KT_CPU_Total",   :limit => 15
    t.float   "KT_CPA_Lwr",     :limit => 15
    t.float   "KT_CPA_Mean",    :limit => 15
    t.float   "KT_CPA_Upr",     :limit => 15
    t.float   "KT_CPA_CV",      :limit => 15
    t.float   "TB_AS_RodDay",   :limit => 15
    t.float   "TB_Gr_Harvest",  :limit => 15
    t.float   "TB_Gr_Release",  :limit => 15
    t.float   "TB_Gr_Total",    :limit => 15
    t.float   "TB_MSW_Harvest", :limit => 15
    t.float   "TB_MSW_Release", :limit => 15
    t.float   "TB_MSW_Total",   :limit => 15
    t.float   "TB_AS_Harvest",  :limit => 15
    t.float   "TB_AS_Release",  :limit => 15
    t.float   "TB_AS_Total",    :limit => 15
    t.float   "TB_CPU_Grilse",  :limit => 15
    t.float   "TB_CPU_MSW",     :limit => 15
    t.float   "TB_CPU_Total",   :limit => 15
    t.float   "TB_CPA_Lwr",     :limit => 15
    t.float   "TB_CPA_Mean",    :limit => 15
    t.float   "TB_CPA_Upr",     :limit => 15
    t.float   "TB_CPA_CV",      :limit => 15
    t.float   "EB_AS_RodDay",   :limit => 15
    t.float   "EB_Gr_Harvest",  :limit => 15
    t.float   "EB_Gr_Release",  :limit => 15
    t.float   "EB_Gr_Total",    :limit => 15
    t.float   "EB_MSW_Harvest", :limit => 15
    t.float   "EB_MSW_Release", :limit => 15
    t.float   "EB_MSW_Total",   :limit => 15
    t.float   "EB_AS_Harvest",  :limit => 15
    t.float   "EB_AS_Release",  :limit => 15
    t.float   "EB_AS_Total",    :limit => 15
    t.float   "EB_CPU_Grilse",  :limit => 15
    t.float   "EB_CPU_MSW",     :limit => 15
    t.float   "EB_CPU_Total",   :limit => 15
    t.float   "LB_AS_RodDay",   :limit => 15
    t.float   "LB_Gr_Harvest",  :limit => 15
    t.float   "LB_Gr_Release",  :limit => 15
    t.float   "LB_Gr_Total",    :limit => 15
    t.float   "LB_MSW_Harvest", :limit => 15
    t.float   "LB_MSW_Release", :limit => 15
    t.float   "LB_MSW_Total",   :limit => 15
    t.float   "LB_AS_Harvest",  :limit => 15
    t.float   "LB_AS_Release",  :limit => 15
    t.float   "LB_AS_Total",    :limit => 15
    t.float   "LB_CPU_Grilse",  :limit => 15
    t.float   "LB_CPU_MSW",     :limit => 15
    t.float   "LB_CPU_Total",   :limit => 15
    t.float   "TS_AS_RodDay",   :limit => 15
    t.float   "TS_Gr_Harvest",  :limit => 15
    t.float   "TS_Gr_Release",  :limit => 15
    t.float   "TS_Gr_Total",    :limit => 15
    t.float   "TS_MSW_Harvest", :limit => 15
    t.float   "TS_MSW_Release", :limit => 15
    t.float   "TS_MSW_Total",   :limit => 15
    t.float   "TS_AS_Harvest",  :limit => 15
    t.float   "TS_AS_Release",  :limit => 15
    t.float   "TS_AS_Total",    :limit => 15
    t.float   "TS_CPU_Grilse",  :limit => 15
    t.float   "TS_CPU_MSW",     :limit => 15
    t.float   "TS_CPU_Total",   :limit => 15
  end

  add_index "tblsportfishingatlanticsalmon", ["WaterBodyID"], :name => "{B2264753-0653-48B6-93B6-759023"
  add_index "tblsportfishingatlanticsalmon", ["SportfishingID"], :name => "SportfishingID"
  add_index "tblsportfishingatlanticsalmon", ["WaterBodyID"], :name => "WATER_ID"

  create_table "tblsportfishingcrownreserve", :primary_key => "SportfishingID", :force => true do |t|
    t.integer "RegulatedWaterID", :limit => 10
    t.string  "Year",             :limit => 4
    t.float   "TB_TS_RodDay",     :limit => 15
    t.float   "TB_Gr_Harvest",    :limit => 15
    t.float   "TB_Gr_Release",    :limit => 15
    t.float   "TB_Gr_Total",      :limit => 15
    t.float   "TB_MSW_Harvest",   :limit => 15
    t.float   "TB_MSW_Release",   :limit => 15
    t.float   "TB_MSW_Total",     :limit => 15
    t.float   "TB_AS_Harvest",    :limit => 15
    t.float   "TB_AS_Release",    :limit => 15
    t.float   "TB_AS_Total",      :limit => 15
    t.float   "TB_CPU_Grilse",    :limit => 15
    t.float   "TB_CPU_MSW",       :limit => 15
    t.float   "TB_CPU_Total",     :limit => 15
    t.float   "TS_BT_Harvest",    :limit => 15
    t.float   "TS_BT_Release",    :limit => 15
    t.float   "TS_BT_Total",      :limit => 15
  end

  add_index "tblsportfishingcrownreserve", ["RegulatedWaterID"], :name => "{771658EA-10AB-4276-AE7C-A4A7E0"
  add_index "tblsportfishingcrownreserve", ["RegulatedWaterID"], :name => "RegulatedWaterID"
  add_index "tblsportfishingcrownreserve", ["SportfishingID"], :name => "SportfishingID"

  create_table "tblstockedfish", :primary_key => "FishStockingID", :force => true do |t|
    t.integer "siteuseid",             :limit => 10
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.string  "FishSpeciesCd",         :limit => 2
    t.integer "FishStockID",           :limit => 10
    t.string  "OtherStock",            :limit => 50
    t.integer "FishMatingID",          :limit => 10
    t.integer "FishStrainCd",          :limit => 10
    t.boolean "BroodstockInd",                       :null => false
    t.string  "FishAge",               :limit => 10
    t.string  "AgeUnitOfMeasure",      :limit => 10
    t.string  "FishAgeClass",          :limit => 20
    t.integer "NoFish",                :limit => 10
    t.integer "FishFacilityID",        :limit => 10
    t.string  "OtherFishFacility",     :limit => 50
    t.string  "FishTankNo",            :limit => 2
    t.boolean "SatelliteRearedInd",                  :null => false
    t.float   "AveLength_cm",          :limit => 15
    t.string  "LengthRange_cm",        :limit => 20
    t.string  "FishLengthType",        :limit => 10
    t.float   "AveWeight_gm",          :limit => 15
    t.string  "WeightRange_gm",        :limit => 20
    t.integer "NoFishMeasured",        :limit => 10
    t.integer "AppliedMarkCd",         :limit => 10
    t.string  "Source",                :limit => 50
  end

  add_index "tblstockedfish", ["FishStockID"], :name => "{42C7EB4F-0D16-4C9E-B72B-E3FAFE"
  add_index "tblstockedfish", ["FishMatingID"], :name => "{4664ED76-C4C5-4F01-94C2-787706"
  add_index "tblstockedfish", ["FishSpeciesCd"], :name => "{69365FA7-DC11-4323-8B3A-9B41CC"
  add_index "tblstockedfish", ["AppliedMarkCd"], :name => "{98DE86FF-08D4-4803-B4A0-6BBE0E"
  add_index "tblstockedfish", ["FishFacilityID"], :name => "{AA01333A-8722-46C3-8FD4-2BF486"
  add_index "tblstockedfish", ["FishAgeClass"], :name => "{BC3A6A6A-7068-4DFD-8F21-E0E9B8"
  add_index "tblstockedfish", ["AquaticActivityID"], :name => "{DA7ACC03-F95D-442C-934E-76D801"
  add_index "tblstockedfish", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblstockedfish", ["AquaticActivityID"], :name => "AquaticActivityID1"
  add_index "tblstockedfish", ["FishMatingID"], :name => "FishMatingID"
  add_index "tblstockedfish", ["FishFacilityID"], :name => "FishRearingFacilID"
  add_index "tblstockedfish", ["FishStockID"], :name => "FishStockID"
  add_index "tblstockedfish", ["FishStockingID"], :name => "FishStockingID"
  add_index "tblstockedfish", ["siteuseid"], :name => "siteuseid"

  create_table "tblstreamattribute", :primary_key => "WaterBodyID", :force => true do |t|
    t.float   "StreamLength_km", :limit => 15
    t.integer "HighestOrder",    :limit => 5
    t.string  "IntermittentInd", :limit => 1
    t.string  "TidalInd",        :limit => 1
  end

  add_index "tblstreamattribute", ["WaterBodyID"], :name => "{A520FBFB-F9B2-44B6-99D7-0C8E1B", :unique => true
  add_index "tblstreamattribute", ["WaterBodyID"], :name => "WATER_ID"

  create_table "tblvibertboxanalysis", :id => false, :force => true do |t|
    t.integer "AquaticActivityID",            :limit => 10
    t.integer "TempAquaticActivityID",        :limit => 10
    t.string  "LocationDesc",                 :limit => 20
    t.float   "LidDepth_cm",                  :limit => 15
    t.float   "WetWeight_Initial_gm",         :limit => 15
    t.float   "WetWeight_Final_gm",           :limit => 15
    t.float   "WetWeight_Net_gm",             :limit => 15
    t.float   "WetWeight_Fines_Percent",      :limit => 15
    t.float   "DryWeight_Total_gm",           :limit => 15
    t.float   "DrytWeight_Box_Rocks_gm",      :limit => 15
    t.float   "DryWeight_Box_Rocks_Percent",  :limit => 15
    t.float   "DryWeight_FineGravel_gm",      :limit => 15
    t.float   "DryWeight_fineGravel_Percent", :limit => 15
    t.float   "DryWeight_Sand_gm",            :limit => 15
    t.float   "DryWeight_Sand_Percent",       :limit => 15
    t.float   "DryWeight_Fines_gm",           :limit => 15
    t.float   "DryWeight_Fines_Percent",      :limit => 15
    t.string  "Comments",                     :limit => 150
  end

  add_index "tblvibertboxanalysis", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblvibertboxanalysis", ["TempAquaticActivityID"], :name => "oldAquaticActivityID"

  create_table "tblwaterbody", :primary_key => "WaterBodyID", :force => true do |t|
    t.string   "DrainageCd",             :limit => 17
    t.string   "WaterBodyTypeCd",        :limit => 4
    t.string   "WaterBodyName",          :limit => 55
    t.string   "WaterBodyName_Abrev",    :limit => 40
    t.string   "WaterBodyName_Alt",      :limit => 40
    t.integer  "WaterBodyComplexID",     :limit => 5
    t.string   "Surveyed_Ind",           :limit => 1
    t.float    "FlowsIntoWaterBodyID",   :limit => 15
    t.string   "FlowsIntoWaterBodyName", :limit => 40
    t.string   "FlowIntoDrainageCd",     :limit => 17
    t.datetime "DateEntered"
    t.datetime "DateModified"
  end

  add_index "tblwaterbody", ["WaterBodyComplexID"], :name => "{267293E5-26E7-418B-9AFA-318DAE"
  add_index "tblwaterbody", ["WaterBodyComplexID"], :name => "CMPLX_ID"
  add_index "tblwaterbody", ["DrainageCd"], :name => "DR_CODE"
  add_index "tblwaterbody", ["FlowsIntoWaterBodyID"], :name => "FLOW_ID"
  add_index "tblwaterbody", ["WaterBodyID"], :name => "WATER_ID"

  create_table "tblwaterbodycomplex", :primary_key => "WaterBodyComplexID", :force => true do |t|
    t.string "WaterBodyComplexName", :limit => 55
    t.string "WaterBodyComplexType", :limit => 4
    t.string "DrainageCd",           :limit => 17
  end

  add_index "tblwaterbodycomplex", ["WaterBodyComplexID"], :name => "CMPLX_ID"
  add_index "tblwaterbodycomplex", ["DrainageCd"], :name => "tblWaterBodyComplexesDrainageCd"

  create_table "tblwaterchemistryanalysis", :id => false, :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.string  "DOE_Program",           :limit => 14
    t.string  "DOE_ProjectNo",         :limit => 10
    t.string  "DOE_StationNo",         :limit => 15
    t.string  "DOE_LabNo",             :limit => 8
    t.string  "DOE_FieldNo",           :limit => 11
    t.float   "SecchiDepth_m",         :limit => 15
    t.float   "SampleDepth_m",         :limit => 15
    t.float   "WaterTemp_C",           :limit => 15
    t.float   "DO",                    :limit => 15
    t.float   "TOXIC_UNIT",            :limit => 15
    t.string  "L_HARD",                :limit => 1
    t.float   "HARD",                  :limit => 15
    t.float   "NO3",                   :limit => 15
    t.string  "L_AL_X",                :limit => 1
    t.float   "AL_X",                  :limit => 15
    t.string  "L_AL_XGF",              :limit => 1
    t.float   "AL_XGF",                :limit => 15
    t.string  "L_ALK_G",               :limit => 1
    t.float   "ALK_G",                 :limit => 15
    t.string  "L_ALK_P",               :limit => 1
    t.float   "ALK_P",                 :limit => 15
    t.string  "L_ALK_T",               :limit => 1
    t.float   "ALK_T",                 :limit => 15
    t.string  "L_AS_XGF",              :limit => 1
    t.float   "AS_XGF",                :limit => 15
    t.string  "L_BA_X",                :limit => 1
    t.float   "BA_X",                  :limit => 15
    t.string  "L_B_X",                 :limit => 1
    t.float   "B_X",                   :limit => 15
    t.string  "L_BR",                  :limit => 1
    t.float   "BR",                    :limit => 15
    t.string  "L_CA_D",                :limit => 1
    t.float   "CA_D",                  :limit => 15
    t.string  "L_CD_XGF",              :limit => 1
    t.float   "CD_XGF",                :limit => 15
    t.string  "L_CHL_A",               :limit => 1
    t.float   "CHL_A",                 :limit => 15
    t.string  "L_CL",                  :limit => 1
    t.float   "CL",                    :limit => 15
    t.string  "L_CL_IC",               :limit => 1
    t.float   "CL_IC",                 :limit => 15
    t.string  "L_CLRA",                :limit => 1
    t.float   "CLRA",                  :limit => 15
    t.string  "L_CO_X",                :limit => 1
    t.float   "CO_X",                  :limit => 15
    t.string  "L_COND",                :limit => 1
    t.float   "COND",                  :limit => 15
    t.float   "COND2",                 :limit => 15
    t.string  "L_CR_X",                :limit => 1
    t.float   "CR_X",                  :limit => 15
    t.string  "L_CR_XGF",              :limit => 1
    t.float   "CR_XGF",                :limit => 15
    t.string  "L_CU_X",                :limit => 1
    t.float   "CU_X",                  :limit => 15
    t.string  "L_CU_XGF",              :limit => 1
    t.float   "CU_XGF",                :limit => 15
    t.string  "L_DOC",                 :limit => 1
    t.float   "DOC",                   :limit => 15
    t.string  "L_F",                   :limit => 1
    t.float   "F",                     :limit => 15
    t.string  "L_FE_X",                :limit => 1
    t.float   "FE_X",                  :limit => 15
    t.string  "L_HG_T",                :limit => 1
    t.float   "HG_T",                  :limit => 15
    t.string  "L_K",                   :limit => 1
    t.float   "K",                     :limit => 15
    t.string  "L_MG_D",                :limit => 1
    t.float   "MG_D",                  :limit => 15
    t.string  "L_MN_X",                :limit => 1
    t.float   "MN_X",                  :limit => 15
    t.string  "L_NA",                  :limit => 1
    t.float   "NA",                    :limit => 15
    t.string  "L_NH3T",                :limit => 1
    t.float   "NH3T",                  :limit => 15
    t.string  "L_NI_X",                :limit => 1
    t.float   "NI_X",                  :limit => 15
    t.string  "L_NO2D",                :limit => 1
    t.float   "NO2D",                  :limit => 15
    t.string  "L_NOX",                 :limit => 1
    t.float   "NOX",                   :limit => 15
    t.string  "L_PB_XGF",              :limit => 1
    t.float   "PB_XGF",                :limit => 15
    t.string  "L_PH",                  :limit => 1
    t.float   "PH",                    :limit => 15
    t.string  "L_PH_GAL",              :limit => 1
    t.float   "PH_GAL",                :limit => 15
    t.string  "L_SB_XGF",              :limit => 1
    t.float   "SB_XGF",                :limit => 15
    t.string  "L_SE_XGF",              :limit => 1
    t.float   "SE_XGF",                :limit => 15
    t.float   "SILICA",                :limit => 15
    t.string  "L_SO4",                 :limit => 1
    t.float   "SO4",                   :limit => 15
    t.string  "L_SO4_IC",              :limit => 1
    t.float   "SO4_IC",                :limit => 15
    t.string  "L_SS",                  :limit => 1
    t.float   "SS",                    :limit => 15
    t.string  "L_TDS",                 :limit => 1
    t.float   "TDS",                   :limit => 15
    t.string  "L_TKN",                 :limit => 1
    t.float   "TKN",                   :limit => 15
    t.string  "L_TL_XGF",              :limit => 1
    t.float   "TL_XGF",                :limit => 15
    t.string  "L_TOC",                 :limit => 1
    t.float   "TOC",                   :limit => 15
    t.string  "L_TP_L",                :limit => 1
    t.float   "TP_L",                  :limit => 15
    t.string  "L_TURB",                :limit => 1
    t.float   "TURB",                  :limit => 15
    t.string  "L_ZN_X",                :limit => 1
    t.float   "ZN_X",                  :limit => 15
    t.string  "L_ZN_XGF",              :limit => 1
    t.float   "ZN_XGF",                :limit => 15
    t.string  "L_O_PHOS",              :limit => 1
    t.float   "O_PHOS",                :limit => 15
    t.float   "BICARB",                :limit => 15
    t.float   "CARB",                  :limit => 15
    t.float   "SAT_PH",                :limit => 15
    t.float   "SAT_NDX",               :limit => 15
  end

  add_index "tblwaterchemistryanalysis", ["AquaticActivityID"], :name => "{A84E8104-E838-4C00-8C7A-E4A3D7"
  add_index "tblwaterchemistryanalysis", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblwaterchemistryanalysis", ["AquaticActivityID"], :name => "AquaticActivityID1"

  create_table "tblwatermeasurement", :primary_key => "WaterMeasurementID", :force => true do |t|
    t.integer "AquaticActivityID",     :limit => 10
    t.integer "TempAquaticActivityID", :limit => 10
    t.integer "TempDataID",            :limit => 10
    t.integer "TemperatureLoggerID",   :limit => 10
    t.integer "HabitatUnitID",         :limit => 10
    t.string  "WaterSourceCd",         :limit => 50
    t.float   "WaterDepth_m",          :limit => 7
    t.string  "TimeofDay",             :limit => 5
    t.integer "OandMCd",               :limit => 10
    t.integer "InstrumentCd",          :limit => 10
    t.float   "Measurement",           :limit => 7
    t.integer "UnitofMeasureCd",       :limit => 10
  end

  add_index "tblwatermeasurement", ["TempAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblwatermeasurement", ["AquaticActivityID"], :name => "AquaticActivityID1"
  add_index "tblwatermeasurement", ["InstrumentCd"], :name => "cdInstrumenttblWaterMeasurement"
  add_index "tblwatermeasurement", ["OandMCd"], :name => "cdOandMtblWaterMeasurement"
  add_index "tblwatermeasurement", ["UnitofMeasureCd"], :name => "cdUnitofMeasuretblWaterMeasurem"
  add_index "tblwatermeasurement", ["WaterSourceCd"], :name => "cdWaterSourcetblWaterMeasurement"
  add_index "tblwatermeasurement", ["AquaticActivityID"], :name => "tblAquaticActivitytblWaterMeasu"
  add_index "tblwatermeasurement", ["TemperatureLoggerID"], :name => "tblWaterTemperatureLoggerDetail"
  add_index "tblwatermeasurement", ["TempDataID"], :name => "TempDataID"
  add_index "tblwatermeasurement", ["TemperatureLoggerID"], :name => "TemperatureLoggerID"
  add_index "tblwatermeasurement", ["WaterMeasurementID"], :name => "WaterMeasurementID"

  create_table "tblwatermeasurement-old", :primary_key => "WaterMeasurementID", :force => true do |t|
    t.integer "AquaticActivityID",    :limit => 10
    t.integer "oldAquaticActivityID", :limit => 10
    t.integer "TempDataID",           :limit => 10
    t.integer "TemperatureLoggerID",  :limit => 10
    t.integer "HabitatUnitID",        :limit => 10
    t.string  "WaterSourceCd",        :limit => 50
    t.float   "SampleDepth_m",        :limit => 7
    t.integer "WaterParameterCd",     :limit => 10
    t.float   "Measurement",          :limit => 7
    t.integer "UnitofMeasureCd",      :limit => 10
  end

  add_index "tblwatermeasurement-old", ["WaterParameterCd"], :name => "{03007D3A-37E5-4D76-A86B-6DEB02"
  add_index "tblwatermeasurement-old", ["oldAquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblwatermeasurement-old", ["AquaticActivityID"], :name => "AquaticActivityID1"
  add_index "tblwatermeasurement-old", ["HabitatUnitID"], :name => "HabitatUnitID"
  add_index "tblwatermeasurement-old", ["TempDataID"], :name => "TempDataID"
  add_index "tblwatermeasurement-old", ["TemperatureLoggerID"], :name => "TemperatureLoggerID"
  add_index "tblwatermeasurement-old", ["WaterMeasurementID"], :name => "WaterMeasurementID"

  create_table "tblwatertemperatureloggerdetails", :primary_key => "TemperatureLoggerID", :force => true do |t|
    t.integer  "AquaticActivityID",          :limit => 10
    t.string   "LoggerNo",                   :limit => 20
    t.string   "BrandName",                  :limit => 30
    t.string   "Model",                      :limit => 20
    t.string   "Resolution",                 :limit => 20
    t.string   "Accuracy",                   :limit => 20
    t.integer  "TempRange_From",             :limit => 10
    t.integer  "TempRange_To",               :limit => 10
    t.string   "DataFileName",               :limit => 75
    t.string   "InstallationDate",           :limit => 10
    t.string   "RemovalDate",                :limit => 10
    t.string   "RecordingStartDate",         :limit => 10
    t.string   "RecordingEndDate",           :limit => 10
    t.boolean  "OutofWaterReadingsOccurred",               :null => false
    t.boolean  "OutofWaterReadingsRemoved",                :null => false
    t.integer  "DistanceFromLeftBank_m",     :limit => 10
    t.integer  "DistanceFromRightBank_m",    :limit => 10
    t.integer  "WaterDepth_cm",              :limit => 10
    t.float    "SampleInterval_min",         :limit => 7
    t.float    "Install_WaterTemp_C",        :limit => 7
    t.float    "Install_AirTemp_C",          :limit => 7
    t.string   "Install_TimeofDay",          :limit => 5
    t.float    "Removal_WaterTemp_C",        :limit => 7
    t.float    "Removal_AirTemp_C",          :limit => 7
    t.string   "Removal_TimeofDay",          :limit => 5
    t.string   "WaterLevel_Install",         :limit => 10
    t.string   "WaterLevel_Removal",         :limit => 10
    t.datetime "DateEntered"
    t.boolean  "IncorporatedInd",                          :null => false
  end

  add_index "tblwatertemperatureloggerdetails", ["TemperatureLoggerID"], :name => "TemperatureLoggerID", :unique => true
  add_index "tblwatertemperatureloggerdetails", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblwatertemperatureloggerdetails", ["LoggerNo"], :name => "LoggerID"

  create_table "tblwatertemperatureloggerdetails-v1", :primary_key => "TemperatureLoggerID", :force => true do |t|
    t.integer  "AquaticActivityID",          :limit => 10
    t.string   "LoggerID",                   :limit => 20
    t.string   "BrandName",                  :limit => 30
    t.string   "Model",                      :limit => 20
    t.string   "Resolution",                 :limit => 20
    t.string   "Accuracy",                   :limit => 20
    t.integer  "TempRange_From",             :limit => 10
    t.integer  "TempRange_To",               :limit => 10
    t.string   "DataFileName",               :limit => 30
    t.string   "InstallationDate",           :limit => 10
    t.string   "RemovalDate",                :limit => 10
    t.string   "RecordingStartDate",         :limit => 10
    t.string   "RecordingEndDate",           :limit => 10
    t.boolean  "OutofWaterReadingsOccurred",               :null => false
    t.boolean  "OutofWaterReadingsRemoved",                :null => false
    t.integer  "DistanceFromLeftBank_m",     :limit => 10
    t.integer  "DistanceFromRightBank_m",    :limit => 10
    t.integer  "WaterDepth_m",               :limit => 10
    t.float    "SampleInterval_min",         :limit => 7
    t.float    "Install_WaterTemp_C",        :limit => 7
    t.float    "Install_AirTemp_C",          :limit => 7
    t.string   "Install_TimeofDay",          :limit => 5
    t.float    "Removal_WaterTemp_C",        :limit => 7
    t.float    "Removal_AirTemp_C",          :limit => 7
    t.string   "Removal_TimeofDay",          :limit => 5
    t.string   "WaterLevel_Install",         :limit => 10
    t.string   "WaterLevel_Removal",         :limit => 10
    t.datetime "DateEntered"
    t.boolean  "IncorporatedInd",                          :null => false
  end

  add_index "tblwatertemperatureloggerdetails-v1", ["TemperatureLoggerID"], :name => "TemperatureLoggerID", :unique => true
  add_index "tblwatertemperatureloggerdetails-v1", ["AquaticActivityID"], :name => "AquaticActivityID"
  add_index "tblwatertemperatureloggerdetails-v1", ["LoggerID"], :name => "LoggerID"

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

end
