class TblAquaticActivity < ActiveRecord::Base
  set_table_name  'tblAquaticActivity'
  set_primary_key 'aquaticactivityid'
  acts_as_importable
  
#  belongs_to :aquatic_site
#  belongs_to :aquatic_activity_code, :foreign_key => 'aquatic_activity_code'
#  
##  acts_as_importable 'tblAquaticActivity'
##  def self.import_from_data_warehouse
##    records = FasterCSV.read("#{RAILS_ROOT}/db/import/tblAquaticActivity.csv")
##    columns = [
##      :id,                           #0
##      :temporary_id,                 #1
##      :project,                      #2
##      :permit_number,                #3
##      :aquatic_program_id,           #4
##      :aquatic_activity_code,        #5
##      :aquatic_method_code,          #6
##      :old_aquatic_site_id,          #7
##      :aquatic_site_id,              #8
##      :start_date,                   #9
##      :end_date,                     #10
##      :agency_code,                  #11
##      :agency2_code,                 #12
##      :agency2_contact,              #13
##      :leader,                       #14
##      :crew,                         #15
##      :weather_conditions,           #16
##      :water_temperature_in_celsius, #17
##      :air_temperature_in_celsius,   #18
##      :water_level,                  #19
##      :water_level_in_cm,            #20
##      :morning_water_level_in_cm,    #21
##      :evening_water_level_in_cm,    #22
##      :siltation,                    #23
##      :primary_activity,             #24
##      :comments,                     #25
##      :entered_at,                   #26
##      :incorporated_at,              #27
##      :transferred_at                #28
##    ]
##    
##    records.collect! do |record| 
##      record[30] = DateTime.now if record[30]  # IncorporateInd
##      record[24] = record[24].to_f if record[24] # WaterLevel_cm
##      record[25] = record[25].to_f if record[25] # WaterLevel_AM_cm
##      record[26] = record[26].to_f if record[26] # WaterLevel_PM_cm
##      
##      start_date = "#{record[9]} #{record[11]}".strip
##      start_date = "#{start_date}/01/01" if start_date.match(/^\d{4}\/?$/)
##      begin
##        record[9] = DateTime.parse start_date unless start_date.empty?
##      rescue
##      end
##      
##      end_date = "#{record[10]} #{record[12]}".strip
##      end_date = "#{end_date}/01/01" if end_date.match(/^\d{4}\/?$/)
##      begin
##        record[10] = DateTime.parse end_date unless end_date.empty?
##      rescue
##      end
##      record.delete_at(11) # delete AquaticActivityStartTime
##      record.delete_at(11) # delete AquaticActivityEndTime
##      record.delete_at(11) # delete Year
##
##      record      
##    end
##    
##    self.import columns, records, { :validate => false }
##  end
#  acts_as_importable 'tblAquaticActivity', :exclude => ['AquaticActivityStartTime', 'AquaticActivityEndTime', 'Year', 'SSMA_Timestamp']
#  import_transformation_for 'AirTemp_C', 'air_temperature_in_celsius'
#  import_transformation_for 'WaterTemp_C', 'water_temperature_in_celsius'
#  import_transformation_for 'DateEntered', 'entered_at'
#  import_transformation_for 'AquaticActivityLeader', 'leader'
#  import_transformation_for 'AgencyCd', 'agency_code'
#  import_transformation_for 'TempAquaticActivityID', 'temporary_id'
#  import_transformation_for 'Agency2Cd', 'agency2_code'
#  import_transformation_for 'PermitNo', 'permit_number'
#  import_transformation_for 'AquaticActivityStartDate', 'start_date' do |record|
#    date = "#{record['AquaticActivityStartDate'.downcase]} #{record['AquaticActivityStartTime']}".strip
#    date = "#{date}/01/01" if date.match(/^\d{4}\/?$/)
#    the_date = nil
#    begin
#      the_date = DateTime.parse date unless date.empty?
#    rescue
#    end
#    the_date
#  end
#  import_transformation_for 'AquaticActivityEndDate', 'end_date' do |record|
#    date = "#{record['AquaticActivityEndDate'.downcase]} #{record['AquaticActivityEndTime'.downcase]}".strip
#    date = "#{date}/01/01" if date.match(/^\d{4}\/?$/)
#    the_date = nil
#    begin
#      the_date = DateTime.parse date unless date.empty?
#    rescue
#    end
#    the_date
#  end
#  import_transformation_for('IncorporatedInd', 'incorporated_at') do |record|
#    DateTime.now if record['IncorporatedInd'.downcase]
#  end
#  import_transformation_for('WaterLevel_cm', 'water_level_in_cm') do |record|
#    record['WaterLevel_cm'.downcase].to_f if record['WaterLevel_cm'.downcase]
#  end
#  import_transformation_for('WaterLevel_AM_cm', 'morning_water_level_in_cm') do |record|
#    record['WaterLevel_AM_cm'.downcase].to_f if record['WaterLevel_AM_cm'.downcase]
#  end
#  import_transformation_for('WaterLevel_PM_cm', 'evening_water_level_in_cm') do |record|
#    record['WaterLevel_PM_cm'.downcase].to_f if record['WaterLevel_PM_cm'.downcase]
#  end
end
