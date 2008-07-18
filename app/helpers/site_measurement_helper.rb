module SiteMeasurementHelper  
  def measurement_group_column(site_measurement)
    site_measurement.measurement.grouping || '-'
  end
  
  def groups(measurements)    
    measurements.collect{ |measurement| measurement.grouping.to_s }.uniq.sort
  end
  
  def measurements_grouped_by(group, measurements)
    measurements.collect { |measurement| measurement if measurement.grouping.to_s == group }.compact.sort_by { |measurement| measurement.name }
  end
  
  def measurement_checks
    flash[:measurement_checks] ||= do_measurement_checks
  end
  
  def do_measurement_checks
    return [] unless aquatic_activity_event_id 
    
    measurement_checks = [:check_substrate_accounted_for, :check_stream_accounted_for, :check_bank_measurements]    
    measurement_checks.inject(Hash.new) do |messages, check|
      messages[check] = self.send(check)
      messages
    end
  end
  
  def check_substrate_accounted_for
    substrate_accounted_for = SiteMeasurement.calculate_substrate_accounted_for aquatic_activity_event_id 
    if substrate_accounted_for > 0 && substrate_accounted_for < 100
      msg = "There is currently #{100 - substrate_accounted_for}% unaccounted for."
    elsif substrate_accounted_for > 100
      msg = "You are currently #{substrate_accounted_for - 100}% over that limit."
    end    
    "All #{Measurement.grouping_for_substrate_measurements} measurements must add up to 100%. #{msg}" if msg
  end
  
  def check_stream_accounted_for
    stream_accounted_for = SiteMeasurement.calculate_stream_accounted_for aquatic_activity_event_id
    if stream_accounted_for > 0 && stream_accounted_for < 100
      msg = "There is currently #{100 - stream_accounted_for}% unaccounted for."
    elsif stream_accounted_for > 100
      msg = "You are currently #{stream_accounted_for - 100}% over that limit."
    end    
    "All #{Measurement.grouping_for_stream_measurements} measurements must add up to 100%. #{msg}" if msg
  end
  
  def check_bank_measurements
    SiteMeasurement.calculate_bank_accounted_for(aquatic_activity_event_id).collect { |name, value| check_bank_measurement(name, value) }.compact
  end
  
  def check_bank_measurement(name, value)
    if value > 0 && value < 100
      "'Left' and 'Right' bank measurements for #{name} do not add up to 100%.  There is #{100 - value}% of bank unaccounted for."
    end
  end
    
  def aquatic_activity_event_id
    active_scaffold_session_storage = session["as:#{params[:eid]}"]
    if active_scaffold_session_storage && active_scaffold_session_storage[:constraints]
      active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]    
    end
  end
end
