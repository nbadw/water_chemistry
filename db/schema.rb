# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define() do

  create_table "cdAgency", :id => false, :force => true do |t|
    t.string "agencycd",     :limit => 10,  :null => false
    t.string "agency",       :limit => 120
    t.string "agencytype",   :limit => 8
    t.string "datarulesind", :limit => 2
  end

  create_table "cdAquaticActivity", :id => false, :force => true do |t|
    t.integer "aquaticactivitycd",                      :null => false
    t.string  "aquaticactivity",         :limit => 100
    t.string  "aquaticactivitycategory", :limit => 60
    t.string  "duration",                :limit => 40
  end

  create_table "cdAquaticActivityMethod", :id => false, :force => true do |t|
    t.integer "aquaticmethodcd"
    t.integer "aquaticactivitycd"
    t.string  "aquaticmethod",     :limit => 60
  end

  create_table "cdInstrument", :id => false, :force => true do |t|
    t.integer "instrumentcd",                       :null => false
    t.string  "instrument",          :limit => 100
    t.string  "instrument_category", :limit => 100
  end

  create_table "cdMeasureInstrument", :id => false, :force => true do |t|
    t.integer "measureinstrumentcd", :null => false
    t.integer "oandmcd"
    t.integer "instrumentcd"
  end

  create_table "cdMeasureUnit", :id => false, :force => true do |t|
    t.integer "measureunitcd",   :null => false
    t.integer "oandmcd"
    t.integer "unitofmeasurecd"
  end

  create_table "cdOandM", :id => false, :force => true do |t|
    t.integer "oandmcd",                          :null => false
    t.string  "oandm_type",        :limit => 32
    t.string  "oandm_category",    :limit => 80
    t.string  "oandm_group",       :limit => 100
    t.string  "oandm_parameter",   :limit => 100
    t.string  "oandm_parametercd", :limit => 60
    t.boolean "oandm_valuesind",                  :null => false
  end

  create_table "cdOandMValues", :id => false, :force => true do |t|
    t.integer "oandmvaluescd",               :null => false
    t.integer "oandmcd"
    t.string  "value",         :limit => 40
  end

  create_table "cdUnitofMeasure", :id => false, :force => true do |t|
    t.integer "unitofmeasurecd"
    t.string  "unitofmeasure",    :limit => 100
    t.string  "unitofmeasureabv", :limit => 20
  end

  create_table "tblAquaticActivity", :id => false, :force => true do |t|
    t.integer  "aquaticactivityid",                       :null => false
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
    t.float    "watertemp_c",              :limit => 4
    t.float    "airtemp_c",                :limit => 4
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
  end

  create_table "tblAquaticSite", :id => false, :force => true do |t|
    t.integer  "aquaticsiteid",                   :null => false
    t.integer  "oldaquaticsiteid"
    t.integer  "riversystemid"
    t.integer  "waterbodyid"
    t.string   "waterbodyname",    :limit => 100
    t.string   "aquaticsitename",  :limit => 200
    t.string   "aquaticsitedesc",  :limit => 500
    t.string   "habitatdesc",      :limit => 100
    t.integer  "reachno"
    t.string   "startdesc",        :limit => 200
    t.string   "enddesc",          :limit => 200
    t.float    "startroutemeas"
    t.float    "endroutemeas"
    t.string   "sitetype",         :limit => 40
    t.string   "specificsiteind",  :limit => 2
    t.string   "georeferencedind", :limit => 2
    t.datetime "dateentered"
    t.boolean  "incorporatedind"
    t.string   "coordinatesource", :limit => 100
    t.string   "coordinatesystem", :limit => 100
    t.string   "xcoordinate",      :limit => 100
    t.string   "ycoordinate",      :limit => 100
    t.string   "coordinateunits",  :limit => 100
    t.string   "comments",         :limit => 300
  end

  create_table "tblAquaticSiteAgencyUse", :id => false, :force => true do |t|
    t.integer "aquaticsiteuseid",                :null => false
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

  create_table "tblDrainageUnit", :id => false, :force => true do |t|
    t.string  "drainagecd",   :limit => 34,  :null => false
    t.string  "level1no",     :limit => 4
    t.string  "level1name",   :limit => 80
    t.string  "level2no",     :limit => 4
    t.string  "level2name",   :limit => 100
    t.string  "level3no",     :limit => 4
    t.string  "level3name",   :limit => 100
    t.string  "level4no",     :limit => 4
    t.string  "level4name",   :limit => 100
    t.string  "level5no",     :limit => 4
    t.string  "level5name",   :limit => 100
    t.string  "level6no",     :limit => 4
    t.string  "level6name",   :limit => 100
    t.string  "unitname",     :limit => 110
    t.string  "unittype",     :limit => 8
    t.string  "borderind",    :limit => 2
    t.integer "streamorder"
    t.float   "area_ha"
    t.float   "area_percent"
    t.string  "cgndb_key",    :limit => 20
    t.string  "drainsinto",   :limit => 80
  end

  create_table "tblEnvironmentalObservations", :id => false, :force => true do |t|
    t.integer "envobservationid",                         :null => false
    t.integer "aquaticactivityid"
    t.string  "observationgroup",          :limit => 100
    t.string  "observation",               :limit => 100
    t.string  "observationsupp",           :limit => 100
    t.integer "pipesize_cm"
    t.boolean "fishpassageobstructionind"
  end

  create_table "tblSample", :id => false, :force => true do |t|
    t.integer "sampleid",                                :null => false
    t.integer "aquaticactivityid"
    t.integer "tempaquaticactivityid"
    t.string  "agencysampleno",           :limit => 20
    t.float   "sampledepth_m",            :limit => 4
    t.string  "watersourcetype",          :limit => 40
    t.integer "samplecollectionmethodcd"
    t.string  "analyzedby",               :limit => 510
  end

  create_table "tblWaterBody", :id => false, :force => true do |t|
    t.integer  "waterbodyid",                           :null => false
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

  create_table "tblWaterMeasurement", :id => false, :force => true do |t|
    t.integer "watermeasurementid",                   :null => false
    t.integer "aquaticactivityid"
    t.integer "tempaquaticactivityid"
    t.integer "tempdataid"
    t.integer "temperatureloggerid"
    t.integer "habitatunitid"
    t.integer "sampleid"
    t.string  "watersourcetype",       :limit => 100
    t.float   "waterdepth_m",          :limit => 4
    t.string  "timeofday",             :limit => 10
    t.integer "oandmcd"
    t.integer "instrumentcd"
    t.float   "measurement",           :limit => 4
    t.integer "unitofmeasurecd"
    t.boolean "detectionlimitind",                    :null => false
    t.string  "comment",               :limit => 510
  end

end
