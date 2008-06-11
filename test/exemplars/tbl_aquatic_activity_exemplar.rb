class TblAquaticActivity < ActiveRecord::Base
  generator_for :rainfall_last24 => TblAquaticActivity.rainfall_last24_options.first
  generator_for :weather_conditions => TblAquaticActivity.weather_conditions_options.first
  generator_for :water_level => TblAquaticActivity.water_level_options.first
  generator_for :aquaticactivitystartdate => Time.now.to_s(:adw)
  generator_for :aquaticactivitystarttime => Time.now.to_s(:time)
  generator_for :aquaticactivityenddate => Time.now.to_s(:adw)
  generator_for :aquaticactivityendtime => Time.now.to_s(:time)
end