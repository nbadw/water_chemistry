class TblWaterMeasurementController < ApplicationController
  active_scaffold do |config|
    config.label = "Results"
    config.columns = [:comment, :instrumentcd, :measurement, :timeofday]
  end
end
