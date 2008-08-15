class WaterChemistrySampleResultController < ApplicationController
  before_filter :find_parameters, :only => [:new, :create, :edit, :update]
  
  active_scaffold do |config|
    config.label = "Parameters"
    config.actions.exclude :search
    config.columns = [:water_chemistry_parameter, :value, :qualifier, :comment]
    config.columns[:water_chemistry_parameter].label = 'Parameter'  

    config.create.label = "Add Water Chemistry Parameter"
  end
  
  private 
  def find_parameters
    @parameters = WaterChemistryParameter.find :all
    if water_chemistry_sample_id = active_scaffold_session_storage[:constraints][:water_chemistry_sample]
      recorded = WaterChemistrySampleResult.find_all_by_water_chemistry_sample_id(water_chemistry_sample_id, :include => :water_chemistry_parameter).collect { |s| s.water_chemistry_parameter }
      @parameters = @parameters - recorded
    end
  end
end
