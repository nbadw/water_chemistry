class TblAquaticActivity < ActiveRecord::Base
  generator_for :aquaticactivitystartdate => Time.now.to_s(:adw)
  generator_for :aquaticactivitystarttime => Time.now.to_s(:time)
  generator_for :aquaticactivityenddate => Time.now.to_s(:adw)
  generator_for :aquaticactivityendtime => Time.now.to_s(:time)
end