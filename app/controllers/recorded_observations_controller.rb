class RecordedObservationsController < ApplicationController
  before_filter :find_observations, :only => [:new, :create, :edit, :update]
  
  active_scaffold :recorded_observation do |config|
    config.label = "Observations"
    config.actions = [:list, :create, :update, :delete]
    
    config.columns = [:aquatic_activity_event_id, :observation, :group, :value, :fish_passage_blocked]
    config.list.columns = [:observation, :group, :value, :fish_passage_blocked]
    config.create.columns = [:observation]    
    config.update.columns = [:observation]
    
    config.create.label = "Record an Observation"
    config.columns[:group].label = "Group"
    config.columns[:value].label = "Observed Value"
    config.columns[:fish_passage_blocked].label = "Fish Passage Blocked?" 

    config.columns[:aquatic_activity_event_id].search_sql = "#{RecordedObservation.table_name}.#{RecordedObservation.column_for_attribute(:aquatic_activity_id).name}"  

    config.columns[:group].sort = { :sql => "#{Observation.table_name}.#{Observation.column_for_attribute(:oand_m_group).name}" }
    
    config.list.sorting =[{ :group => :asc }]
        
    config.create.persistent = true
  end
  
  def find_observations
    @observations = Observation.all
    if aquatic_activity_event_id = active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]
      recorded = RecordedObservation.for_aquatic_activity_event(aquatic_activity_event_id).collect { |captured| captured.observation }
      #recorded = RecordedObservation.find_all_by_aquatic_activity_event_id(aquatic_activity_event_id, :include => :observation).collect { |o| o.observation }
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
  
  protected
  def before_create_save(site_observation)
    if value = params[:record][:fish_passage_blocked]
      site_observation.fish_passage_blocked = value == 'on'
    end
    
    if value = params[:record][:value_observed]
      site_observation.value_observed = value
    end
  end  
  
  # A simple method to find and prepare an example new record for the form
  # May be overridden to customize the behavior (add default values, for instance)
  def do_new
    @record = active_scaffold_config.model.new
    #apply_constraints_to_record(@record)
    @record
  end
end
