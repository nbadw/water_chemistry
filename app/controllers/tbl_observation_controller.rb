class TblObservationController < ApplicationController
  active_scaffold do |config|
    config.label = "Observations"
    config.columns = [:observation_code, :observation_group]
    config.columns[:observation_group].label = "Group"
    config.columns[:observation_code].label = "Observation"
    config.actions = [:list, :create, :delete]
    
    config.create.persistent = true
    config.create.columns = [:observation_code]
  end
  
  alias_method :active_scaffold_new, :new
  def new
    @observation_groups = {}
    CdOAndM.find(:all).each do |observation|
      next unless observation.oandm_type == 'Observation'
      group = @observation_groups[observation.group] ||= []
      group << observation
    end
    @sorted_groups = @observation_groups.collect { |key, value| key }.sort
    active_scaffold_new
  end
  
  def before_create_save(record)
    record.aquaticactivityid = params[:aquatic_activity_id]
  end
end
