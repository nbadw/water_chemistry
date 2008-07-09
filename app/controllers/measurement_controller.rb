class MeasurementController < ApplicationController
  active_scaffold do |config|
    config.label = "Measurements"
    config.columns = [:name, :measured_value, :grouping]
    config.columns[:measurement_group].label = "Group"
    config.columns[:measurement_code].label = "Measurement"
    config.columns[:measurement].label = "Value"
    config.actions = [:list, :create, :delete]
    
    config.create.persistent = true
    config.create.columns = [:measurement_code, :measurement]
  end
  
  alias_method :active_scaffold_new, :new
  def new
    @measurement_groups = {}
    CdOAndM.find(:all).each do |measurement|
      next if measurement.oandm_type != 'Measurement' || measurement.group == 'Chemical'
      group = @measurement_groups[measurement.group] ||= []
      group << measurement
    end
    @sorted_groups = @measurement_groups.collect { |key, value| key }.sort
    active_scaffold_new
  end
  
  def before_create_save(record)
    record.aquaticactivityid = params[:aquatic_activity_id]
  end
end
