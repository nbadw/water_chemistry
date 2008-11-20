class RecordedChemicalsController < ApplicationController
  helper RecordedChemicalsHelper
  
  before_filter :login_required
  before_filter :find_chemicals, :only => [:new, :create, :edit, :update]
  
  active_scaffold :water_measurement do |config|      
    config.label = "Lab Results"
    config.actions = [:list, :create, :update, :delete]   
    
    config.columns = [:parameter_name, :parameter_code, :measurement, :qualifier_cd, :comment]
    config.list.columns = [:parameter_name, :parameter_code, :measurement, :unit_of_measure, :qualifier_cd, :comment]
    config.create.columns = [:parameter, :measurement, :unit_of_measure, :qualifier_cd, :comment]
    config.update.columns = [:measurement, :unit_of_measure, :qualifier_cd, :comment]

    config.columns[:measurement].label = "Value"
    config.columns[:qualifier_cd].label = "Qualifier"
    
    config.create.persistent = true
  end
  
  def on_chemical_change
    chemical = Measurement.find params[:chemical_id]
    render :update do |page| 
      page.replace_html 'record[unit_of_measure]', :inline => '<%= options_from_collection_for_select(units, :unitof_measure_cd, :name_and_unit) %>', :locals => { :units => chemical.units_of_measure } 
      if chemical.units_of_measure.empty?
        page << "$('record[unit_of_measure]').disable();"
      else
        page << "$('record[unit_of_measure]').enable();"
      end
    end  
  end
  
  protected
  def do_new
    @record = active_scaffold_config.model.new
    @record
  end
  
  def before_create_save(recorded_chemical)
    chemical_parameter_id = params[:record_parameter]
    recorded_chemical.oand_m_cd = chemical_parameter_id
  end
  
  def find_chemicals
    @chemicals = Measurement.chemicals.sort_by { |chemical| chemical.parameter.downcase }
    sample_id = active_scaffold_session_storage[:constraints][:sample]
    recorded = WaterMeasurement.recorded_chemicals(sample_id)
    recorded_ids = recorded.collect { |chem| chem.id }
    @chemicals.delete_if do |chem|
      recorded_ids.include?(chem.id)
    end
  end
  
  def find_current_aquatic_activity_event
    if active_scaffold_session_storage[:constraints] && active_scaffold_session_storage[:constraints][:sample]   
      sample = Sample.find(active_scaffold_session_storage[:constraints][:sample], :include => :aquatic_activity_event)
      @current_aquatic_activity_event = sample.aquatic_activity_event
    end
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
end
