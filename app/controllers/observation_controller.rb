class ObservationController < ApplicationController
  active_scaffold :site_observation do |config|
    config.label = "Observations"
    config.actions = [:list, :create, :delete]
    config.columns = [:observation, :group, :value_observed, :fish_passage_blocked]
    config.columns[:value_observed].label = "Observed Value"
    config.columns[:fish_passage_blocked].label = "Fish Passage Blocked?"    
    
    config.list.sorting =[{ :group => :asc }]
    
    config.create.persistent = true
    config.create.label = "Record an Observation"
    config.create.columns = [:observation]
  end
  
  alias_method :active_scaffold_new, :new
  def new
    @observations = Observation.find(:all)
    if aquatic_activity_event_id = active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]
      recorded = SiteObservation.find_all_by_aquatic_activity_event_id(aquatic_activity_event_id, :include => :observation).collect { |o| o.observation }
      @observations = @observations - recorded
    end
    active_scaffold_new
  end
  
  def on_observation_change
    render :partial => 'on_observation_change', :locals => { :observation => Observation.find(params[:observation_id]) }
  end
  
  def before_create_save(record)
    if value = params[:record][:fish_passage_blocked]
      record.fish_passage_blocked = value == 'on'
    end
    
    if value = params[:record][:value_observed]
      record.value_observed = value
    end
  end
end
