module SiteMeasurementHelper  
  def groups(measurements)    
    measurements.collect{ |measurement| measurement.grouping.to_s }.uniq.sort
  end
  
  def measurements_grouped_by(group, measurements)
    measurements.collect { |measurement| measurement if measurement.grouping.to_s == group }.compact.sort_by { |measurement| measurement.name }
  end
  
  def substrate_accounted_for
    flash[:substrate_accounted_for] ||= SiteMeasurement.calculate_substrate_accounted_for aquatic_activity_event 
  end
  
  def stream_accounted_for
    flash[:stream_accounted_for] ||= SiteMeasurement.calculate_stream_accounted_for aquatic_activity_event
  end
    
  def aquatic_activity_event
    active_scaffold_session_storage = session["as:#{params[:eid]}"]
    active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]    
  end
end
