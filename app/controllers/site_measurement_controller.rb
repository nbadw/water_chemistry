class SiteMeasurementController < ApplicationController
  active_scaffold do |config|
    config.label = "Measurements"
    config.actions = [:list, :create, :delete]
    config.columns = [:measurement, :value_measured, :unit_of_measure, :instrument, :bank]
    
    config.create.persistent = true
  end
  
  def new
    @measurements = Measurement.find(:all)
    if aquatic_activity_event_id = active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]
      recorded = SiteMeasurement.find_all_by_aquatic_activity_event_id(aquatic_activity_event_id, :include => :measurement).collect { |sm| sm.measurement }
      @measurements = @measurements - recorded
    end
    super
  end
  
  def on_measurement_change
    measurement = Measurement.find params[:measurement_id]
    render :update do |page|
      page.replace_html 'instrument', :inline => '<%= options_from_collection_for_select(instruments, :instrument_id, :name) %>', :locals => { :instruments => measurement.instruments } 
      page.replace_html 'unit_of_measure', :inline => '<%= options_from_collection_for_select(units_of_measure, :unit_of_measure_id, :name_and_unit ) %>', :locals => { :units_of_measure => measurement.units_of_measure } 
      measurement.bank_measurement? ? page.show('bank_measurement') : page.hide('bank_measurement')
    end    
  end
end
