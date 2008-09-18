class RecordedChemicalsController < ApplicationController
  before_filter :find_chemicals, :only => [:new, :create, :edit, :update]
  
  active_scaffold :water_measurement do |config|      
    config.label = "Results"
    config.actions = [:list, :create, :update, :delete]   
    
    config.columns = [:parameter_name, :parameter_code, :measurement, :qualifier_cd]
    config.list.columns = [:parameter_name, :parameter_code, :measurement, :qualifier_cd]
    config.create.columns = [:parameter, :measurement, :qualifier_cd]
    config.update.columns = [:parameter, :measurement, :qualifier_cd]

    config.columns[:measurement].label = "Value"
    config.columns[:qualifier_cd].label = "Qualifier"
  end
  
  def find_chemicals
    @chemicals = Measurement.chemical.sort_by { |chemical| chemical.parameter.downcase }
    sample_id = active_scaffold_session_storage[:constraints][:sample]
    recorded = WaterMeasurement.for_sample(sample_id).collect { |captured| captured.o_and_m }
    @chemicals = @chemicals - recorded
  end
end
