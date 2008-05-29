class TblWaterMeasurement < ActiveRecord::Base
  set_table_name  'tblWaterMeasurement'
  set_primary_key 'watermeasurementid'
  acts_as_importable
#  acts_as_importable 'tblWaterMeasurement_New', :primary_key => 'WaterMeasurementID'
#  import_transformation_for('TimeofDay', 'time_of_day') do |record|
#    time_of_day = record['TimeofDay'.downcase].strip
#    DateTime.parse time_of_day unless time_of_day.empty?
#  end
end
