class ActivityEvent < ActiveRecord::Base
  def self.import_from_datawarehouse(attributes)
    record = ActivityEvent.new   
    record.id = attributes['aquaticactivityid']
    record.project = attributes['project']
    record.permit_number = attributes['permitno']
    record.aquatic_program_id = attributes['aquaticprogramid']
    record.aquatic_activity_code = attributes['aquaticactivitycd']
    record.aquatic_method_code = attributes['aquaticmethodcd']
    record.old_aquatic_site_id = attributes['oldaquaticsiteid']
    record.aquatic_site_id = attributes['aquaticsiteid']
    
    start_date = "#{attributes['aquaticactivitystartdate']} #{attributes['aquaticactivitystarttime']}".strip
    record.starts_at = DateTime.parse unless start_date.empty?
    end_date = "#{attributes['aquaticactivityendate']} #{attributes['aquaticactivityendtime']}".strip
    record.ends_at = DateTime.parse end_date unless end_date.empty?
    
    record.agency_code = attributes['agencycd']
    record.agency2_code = attributes['agency2cd']
    record.agency2_contact = attributes['agency2contact']
    record.aquatic_activity_leader = attributes['aquaticactivityleader']
    record.crew = attributes['crew']
    record.weather_conditions = attributes['weatherconditions']
    record.water_temp_in_celsius = attributes['watertemp_c']
    record.air_temp_in_celsius = attributes['airtemp_c']
    record.water_level = attributes['waterlevel']
    record.water_level_in_cm = attributes['waterlevel_cm']
    record.morning_water_level_in_cm = attributes['waterlevel_am_cm']
    record.evening_water_level_in_cm = attributes['waterlevel_pm_cm']
    record.siltation = attributes['siltation']
    record.primary_activity = attributes['primaryactivityind']
    record.comments = attributes['comments']
    
    record.entered_at = attributes['dateentered']
    record.incorporated_at = attributes['incorporatedind'] ? DateTime.now : nil
    record.transferred_at = attributes['datetransferred']
    record.save(false)
  end
end
