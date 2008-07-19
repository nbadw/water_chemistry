class SiteMeasurementController < ApplicationController
  before_filter :find_measurements, :only => [:new, :create, :edit, :update]
  
  active_scaffold do |config|
    config.label = "Measurements"
    config.actions = [:list, :create, :update, :delete]
    config.columns = [:measurement, :measurement_group, :value_measured, :unit_of_measure, :instrument, :bank]
    config.columns[:measurement_group].label = "Group"    
    
    config.create.persistent = true
    config.create.columns.exclude :measurement_group
    
    config.update.columns.exclude :measurement_group
        
    config.columns[:measurement_group].sort = { :sql => "#{Measurement.table_name}.grouping" }
    config.list.sorting =[{ :measurement_group => :asc }]
  end
  
  def on_measurement_change
    measurement = Measurement.find params[:measurement_id]
    render :update do |page|
      page.replace_html 'record[instrument]', :inline => '<%= options_from_collection_for_select(instruments, :instrument_id, :name) %>', :locals => { :instruments => measurement.instruments } 
      page.replace_html 'record[unit_of_measure]', :inline => '<%= options_from_collection_for_select(units_of_measure, :unit_of_measure_id, :name_and_unit ) %>', :locals => { :units_of_measure => measurement.units_of_measure }       
      page.show 'instrument'
      page.show 'unit_of_measure'
      page.show 'value_measured'
      measurement.bank_measurement? ? page.show('bank') : page.hide('bank')
    end    
  end
  
  private 
  def find_measurements
    @measurements = Measurement.find(:all) - recorded_measurements
  end
  
  def recorded_measurements
    constraints = active_scaffold_session_storage[:constraints] || {}
    aquatic_activity_event_id = constraints[:aquatic_activity_event_id]
    aquatic_activity_event_id ? SiteMeasurement.find_recorded_measurements(aquatic_activity_event_id) : []   
  end
end
