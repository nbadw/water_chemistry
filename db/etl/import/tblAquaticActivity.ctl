# ETL Control file
columns = [:aquaticactivityid, :tempaquaticactivityid, :project, :permitno, 
    :aquaticprogramid, :aquaticactivitycd, :aquaticmethodcd, :oldaquaticsiteid,
    :aquaticsiteid, :aquaticactivitystartdate, :aquaticactivityenddate, 
    :aquaticactivitystarttime, :aquaticactivityendtime, :year, :agencycd, 
    :agency2cd, :agency2contact, :aquaticactivityleader, :crew, :weatherconditions,
    :watertemp_c, :airtemp_c, :waterlevel, :waterlevel_cm, :waterlevel_am_cm,
    :waterlevel_pm_cm, :siltation, :primaryactivityind, :comments, :dateentered, 
    :incorporatedind, :datetransferred]
outfile = 'output/aquatic_activities.txt'

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "tblaquaticactivity"
},  columns

destination :out, { 
  :file => outfile
}, { 
  :order => columns 
} 

post_process :bulk_import, { 
  :file => outfile, 
  :columns => columns, 
  :field_separator => ",", 
  :target => :operational, 
  :table => "tblaquaticactivity"
}