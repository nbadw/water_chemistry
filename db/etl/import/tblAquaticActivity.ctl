# ETL Control file
src_columns = [:aquaticactivityid, :tempaquaticactivityid, :project, :permitno, :aquaticprogramid,
  :aquaticactivitycd, :aquaticmethodcd, :oldaquaticsiteid, :aquaticsiteid, :aquaticactivitystartdate,
  :aquaticactivityenddate, :aquaticactivitystarttime, :aquaticactivityendtime, :year,
  :agencycd, :agency2cd, :agency2contact, :aquaticactivityleader, :crew, :weatherconditions,
  :watertemp_c, :airtemp_c, :waterlevel, :waterlevel_cm, :waterlevel_am_cm, :waterlevel_pm_cm,
  :siltation, :primaryactivityind, :comments, :dateentered, :incorporatedind, :datetransferred]
dst_columns = [:id, :project, :permit_no, :aquatic_program_id, :aquatic_activity_id, :aquatic_activity_method_id,
  :aquatic_site_id, :start_date, :end_date, :agency_id, :agency2_id, :agency2_contact, :activity_leader,
  :crew, :weather_conditions, :water_temperature_c, :air_temperature_c, :water_level, :water_level_cm, 
  :morning_water_level_cm, :evening_water_level_cm, :siltation, :primary_activity, :comments, :rainfall_last24,
  :imported_at, :exported_at, :created_at, :updated_at]
outfile = "output/aquatic_activity_events.csv"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "tblAquaticActivity"
}, src_columns

rename :aquaticactivityid, :id
rename :permitno, :permit_no
rename :aquaticprogramid, :aquatic_program_id
rename :aquaticactivitycd, :aquatic_activity_id
rename :aquaticmethodcd, :aquatic_activity_method_id
rename :aquaticsiteid, :aquatic_site_id
rename :agencycd, :agency_id
rename :agency2cd, :agency2_id
rename :agency2contact, :agency2_contact
rename :aquaticactivityleader, :activity_leader
rename :weatherconditions, :weather_conditions
rename :watertemp_c, :water_temperature_c
rename :airtemp_c, :air_temperature_c
rename :waterlevel, :water_level
rename :waterlevel_cm, :water_level_cm
rename :waterlevel_am_cm, :morning_water_level_cm
rename :waterlevel_pm_cm, :evening_water_level_cm
rename :primaryactivityind, :primary_activity

transform :agency_id,  :decode, :decode_table_path => 'decode/agency_table.txt', :default_value => ''
transform :agency2_id, :decode, :decode_table_path => 'decode/agency_table.txt', :default_value => ''

before_write do |row|     
    row[:primary_activity] = row[:primary_activity] == 'true' ? 1 : 0
    row[:created_at] = DateTime.parse(row[:dateentered]) rescue DateTime.now
    if row[:incorporatedind] == 'true'      
      row[:exported_at] = DateTime.parse(row[:datetransferred]) rescue DateTime.now
    end
    row[:start_date] = DateTime.parse("#{row[:aquaticactivitystartdate]} #{row[:aquaticactivitystarttime]}".strip) rescue ''
    row[:end_date] = DateTime.parse("#{row[:aquaticactivityenddate]} #{row[:aquaticactivityendtime]}".strip) rescue ''
    row
end
before_write :check_exist, :target => RAILS_ENV, :table => "aquatic_activity_events", :columns => [:id]

destination :out, { 
  :file => outfile
}, { 
  :order => dst_columns,
  :virtual => { 
    :updated_at => Time.now,
    :imported_at => Time.now
  }  
} 

post_process :bulk_import, { 
  :file => outfile, 
  :columns => dst_columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => "aquatic_activity_events"
}