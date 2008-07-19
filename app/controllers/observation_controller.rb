class ObservationController < ApplicationController
  before_filter :find_observations, :only => [:new, :create, :edit, :update]
  
  active_scaffold :site_observation do |config|
    config.label = "Observations"
    config.actions = [:list, :create, :update, :delete]
    config.columns = [:observation, :observation_group, :value_observed, :fish_passage_blocked]
    config.columns[:observation_group].label = "Group"
    config.columns[:value_observed].label = "Observed Value"
    config.columns[:fish_passage_blocked].label = "Fish Passage Blocked?"    
    
    config.columns[:observation_group].sort = { :sql => "#{Observation.table_name}.grouping" }
    config.list.sorting =[{ :observation_group => :asc }]
        
    config.create.persistent = true
    config.create.label = "Record an Observation"
    config.create.columns = [:observation]
    
    config.update.columns = [:observation]
  end
  
  def find_observations
    @observations = Observation.find(:all)
    if aquatic_activity_event_id = active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]
      recorded = SiteObservation.find_all_by_aquatic_activity_event_id(aquatic_activity_event_id, :include => :observation).collect { |o| o.observation }
      @observations = @observations - recorded
    end
  end
  
  def on_observation_change
    observation = Observation.find params[:observation_id]
    @record = SiteObservation.new(:observation => observation)
    render :update do |page|   
      page.replace_html 'value_observed_input', :inline => '<%= value_observed_input(@record) %>'  
      page.show 'value_observed'
      observation.fish_passage_blocked_observation? ? page.show('fish_passage_blocked') : page.hide('fish_passage_blocked')
    end   
  end
  
  def before_create_save(site_observation)
    if value = params[:record][:fish_passage_blocked]
      site_observation.fish_passage_blocked = value == 'on'
    end
    
    if value = params[:record][:value_observed]
      site_observation.value_observed = value
    end
  end
end
