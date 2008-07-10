module SiteMeasurementHelper
  def groups(measurements)    
    measurements.collect{ |measurement| measurement.grouping.to_s }.uniq.sort
  end
  
  def measurements_grouped_by(group, measurements)
    measurements.collect { |measurement| measurement if measurement.grouping.to_s == group }.compact.sort_by { |measurement| measurement.name }
  end
end
