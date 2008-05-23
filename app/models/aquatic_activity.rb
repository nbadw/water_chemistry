class AquaticActivity < ActiveRecord::Base
  belongs_to :aquatic_site
  belongs_to :aquatic_activity_code, :foreign_key => 'aquatic_activity_code'
  
  acts_as_importable 'tblAquaticActivity', :exclude => ['AquaticActivityStartTime', 'AquaticActivityEndTime', 'Year', 'SSMA_Timestamp']
  import_transformation_for 'AirTemp_C', 'air_temperature_in_celsius'
  import_transformation_for 'WaterTemp_C', 'water_temperature_in_celsius'
  import_transformation_for 'DateEntered', 'entered_at'
  import_transformation_for 'AquaticActivityLeader', 'leader'
  import_transformation_for 'AgencyCd', 'agency_code'
  import_transformation_for 'TempAquaticActivityID', 'temporary_id'
  import_transformation_for 'Agency2Cd', 'agency2_code'
  import_transformation_for 'PermitNo', 'permit_number'
  import_transformation_for 'AquaticActivityStartDate', 'start_date' do |record|
    date = "#{record['AquaticActivityStartDate'.downcase]} #{record['AquaticActivityStartTime']}".strip
    DateTime.parse date unless date.empty?
  end
  import_transformation_for 'AquaticActivityEndDate', 'end_date' do |record|
    date = "#{record['AquaticActivityEndDate'.downcase]} #{record['AquaticActivityEndTime'.downcase]}".strip
    DateTime.parse date unless date.empty?
  end
  import_transformation_for('IncorporatedInd', 'incorporated_at') do |record|
    DateTime.now if record['IncorporatedInd'.downcase]
  end
  import_transformation_for('WaterLevel_cm', 'water_level_in_cm') do |record|
    record['WaterLevel_cm'.downcase].to_f if record['WaterLevel_cm'.downcase]
  end
  import_transformation_for('WaterLevel_AM_cm', 'morning_water_level_in_cm') do |record|
    BigDecimal.new(record['WaterLevel_AM_cm'.downcase]) if record['WaterLevel_AM_cm'.downcase]
  end
  import_transformation_for('WaterLevel_PM_cm', 'evening_water_level_in_cm') do |record|
    BigDecimal.new(record['WaterLevel_PM_cm'.downcase]) if record['WaterLevel_PM_cm'.downcase]
  end
end
