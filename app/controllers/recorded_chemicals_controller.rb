class RecordedChemicalsController < ApplicationController
  helper RecordedChemicalsHelper
  before_filter :login_required
  before_filter :find_chemicals, :only => [:new, :create, :edit, :update]
  
  active_scaffold :water_measurement do |config|      
    config.label = "Results"
    config.actions = [:list, :create, :update, :delete]   
    
    config.columns = [:parameter_name, :parameter_code, :measurement, :qualifier_cd, :comment]
    config.list.columns = [:parameter_name, :parameter_code, :measurement, :qualifier_cd, :comment]
    config.create.columns = [:parameter, :measurement, :qualifier_cd, :comment]
    config.update.columns = [:measurement, :qualifier_cd, :comment]

    config.columns[:measurement].label = "Value"
    config.columns[:qualifier_cd].label = "Qualifier"
    
    config.create.persistent = true
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
end
