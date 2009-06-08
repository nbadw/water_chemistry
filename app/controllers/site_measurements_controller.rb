class SiteMeasurementsController < ApplicationController
  helper RecordedMeasurementsHelper
  before_filter :login_required
  before_filter :find_measurements, :only => [:new, :create, :edit, :update]  
  
  active_scaffold do |config|
    config.actions = [:list, :create, :update, :delete]
    
    config.columns        = [:aquatic_activity_event_id, :o_and_m, :group, :instrument, :unit_of_measure, :measurement, :bank]
    config.list.columns   = [:o_and_m, :group, :measurement, :instrument, :bank]
    config.create.columns = [:o_and_m, :instrument, :unit_of_measure, :measurement, :bank]
    config.update.columns = [:instrument, :unit_of_measure, :measurement, :bank]
    
    # i18n labels
    config.label                           = :site_measurements_label.l
    config.create.label                    = :site_measurements_create_label.l
    config.columns[:o_and_m].label         = :site_measurements_o_and_m_label.l
    config.columns[:group].label           = :site_measurements_group_label.l
    config.columns[:instrument].label      = :site_measurements_instrument_label.l
    config.columns[:unit_of_measure].label = :site_measurements_unit_of_measure_label.l
    config.columns[:measurement].label     = :site_measurements_measurement_label.l
    config.columns[:bank].label            = :site_measurements_bank_label.l

    config.columns[:aquatic_activity_event_id].search_sql =
      "#{SiteMeasurement.table_name}.#{SiteMeasurement.column_for_attribute(:aquatic_activity_id).name}"

    config.create.persistent = true
    
    config.columns[:group].sort = { :sql => "#{Measurement.table_name}.#{Measurement.column_for_attribute(:oand_m_group).name}" }
    config.list.sorting =[{ :group => :asc }]
  end
  
  def on_measurement_change
    measurement = Measurement.find params[:o_and_m_id]
    render :update do |page|
      page.replace_html 'record[instrument]', :inline => '<%= options_from_collection_for_select(instruments, :instrument_cd, :name) %>', :locals => { :instruments => measurement.instruments } 
      page.replace_html 'record[unit_of_measure]', :inline => '<%= options_from_collection_for_select(units_of_measure, :unitof_measure_cd, :name_and_unit ) %>', :locals => { :units_of_measure => measurement.units_of_measure }       
      page.show 'instrument'
      page.show 'unit_of_measure'
      page.show 'measurement'
      measurement.bank_ind ? page.show('bank') : page.hide('bank')
    end    
  end
  
  protected  
  def find_current_aquatic_activity_event
    constraints = active_scaffold_session_storage[:constraints] 
    if constraints && constraints[:aquatic_activity_event_id]
      @current_aquatic_activity_event = AquaticActivityEvent.find(constraints[:aquatic_activity_event_id])
    end
  end
  
  def find_measurements
    all = Measurement.site 
    recorded_ids = recorded_measurements.collect { |meas| meas.id }
    all.delete_if { |meas| recorded_ids.include?(meas.id) }
    @measurements = all
  end
  
  def recorded_measurements
    if current_aquatic_activity_event
      recorded = SiteMeasurement.recorded_measurements(current_aquatic_activity_event.id)
    end
    recorded || []
  end

  def create_authorized?
    current_aquatic_activity_event_owned_by_current_agency?
  end
  
  def update_authorized?
    current_aquatic_activity_event_owned_by_current_agency?
  end
  
  def delete_authorized?
    current_aquatic_activity_event_owned_by_current_agency?
  end  
  
  def current_aquatic_activity_event_owned_by_current_agency?
    if current_agency && current_aquatic_activity_event
      current_agency == current_aquatic_activity_event.agency || current_agency == current_aquatic_activity_event.secondary_agency
    end
  end
  
  def do_new
    @record = active_scaffold_config.model.new
    @record
  end
  
  def do_create
    begin
      active_scaffold_config.model.transaction do
        @record = update_record_from_params(active_scaffold_config.model.new, active_scaffold_config.create.columns, params[:record])
        aquatic_activity_event = active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]    
        @record.aquatic_activity_id = aquatic_activity_event
        @record.bank = nil unless @record.o_and_m.bank_ind
                  
        before_create_save(@record)
        self.successful = [@record.valid?, @record.associated_valid?].all? {|v| v == true} # this syntax avoids a short-circuit
        if successful?
          @record.save! and @record.save_associated!
          after_create_save(@record)
        end
      end
    rescue ActiveRecord::RecordInvalid
    end
  end 
end
