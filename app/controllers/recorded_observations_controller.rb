class RecordedObservationsController < ApplicationController
  helper RecordedObservationsHelper
  before_filter :find_observations, :only => [:new, :create, :edit, :update]
  
  active_scaffold :recorded_observation do |config|
    config.label = "Observations"
    config.actions = [:list, :create, :update, :delete]
    
    config.columns = [:aquatic_activity_event_id, :observation, :group, :value_observed, :fish_passage_obstruction_ind]
    config.list.columns = [:observation, :group, :value_observed, :fish_passage_obstruction_ind]
    config.create.columns = [:observation]    
    config.update.columns = [:observation]
    
    config.create.label = "Record an Observation"
    config.columns[:group].label = "Group"
    config.columns[:value_observed].label = "Observed Value"
    config.columns[:fish_passage_obstruction_ind].label = "Fish Passage Blocked?" 

    config.columns[:aquatic_activity_event_id].search_sql = "#{RecordedObservation.table_name}.#{RecordedObservation.column_for_attribute(:aquatic_activity_id).name}"  

    config.columns[:group].sort = { :sql => "#{Observation.table_name}.#{Observation.column_for_attribute(:oand_m_group).name}" }
    
    config.list.sorting =[{ :group => :asc }]
        
    config.create.persistent = true
  end
  
  def find_observations
    @observations = Observation.all
    
    if active_scaffold_session_storage[:constraints] && active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]
      aquatic_activity_event_id = active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]
      recorded = RecordedObservation.for_aquatic_activity_event(aquatic_activity_event_id).collect { |captured| captured.observation }
      #recorded = RecordedObservation.find_all_by_aquatic_activity_event_id(aquatic_activity_event_id, :include => :observation).collect { |o| o.observation }
      @observations = @observations - recorded
    end
  end
  
  def on_observation_change
    observation = Observation.find params[:observation_id]
    @record = RecordedObservation.new(:observation => observation)
    render :update do |page|   
      page.replace_html 'value_observed_input', :inline => '<%= value_observed_input(@record) %>'  
      page.show 'value_observed'
      observation.fish_passage_ind ? page.show('fish_passage_blocked') : page.hide('fish_passage_blocked')
    end   
  end
  
  protected  
  # A simple method to find and prepare an example new record for the form
  # May be overridden to customize the behavior (add default values, for instance)
  def do_new
    @record = active_scaffold_config.model.new
    @record
  end
  
  def do_create
    begin
      active_scaffold_config.model.transaction do
        @record = update_record_from_params(active_scaffold_config.model.new, active_scaffold_config.create.columns, params[:record])
        observation = params[:record][:observation]          
        value_observed = params[:record][:value_observed]
        aquatic_activity_event = active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]    
        fish_passage_blocked = params[:record][:fish_passage_blocked]

        # observation must be set before value_observed
        @record.oand_m_cd = observation
        @record.value_observed = value_observed    
        @record.aquatic_activity_id = aquatic_activity_event
        @record.fish_passage_obstruction_ind = (fish_passage_blocked == 'on') if fish_passage_blocked    
                  
        #apply_constraints_to_record(@record, :allow_autosave => true)
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
  
  # A complex method to update a record. The complexity comes from the support for subforms, and saving associated records.
  # If you want to customize this algorithm, consider using the +before_update_save+ callback
  def do_update
    @record = find_if_allowed(params[:id], :update)
    begin
      active_scaffold_config.model.transaction do
        @record = update_record_from_params(@record, active_scaffold_config.update.columns, params[:record])
        
        observation = params[:record][:observation]          
        value_observed = params[:record][:value_observed]
        aquatic_activity_event = active_scaffold_session_storage[:constraints][:aquatic_activity_event_id]    
        fish_passage_blocked = params[:record][:fish_passage_blocked]

        # observation must be set before value_observed
        @record.oand_m_cd = observation
        @record.value_observed = value_observed    
        @record.aquatic_activity_id = aquatic_activity_event
        @record.fish_passage_obstruction_ind = (fish_passage_blocked == 'on') if fish_passage_blocked    
               
        before_update_save(@record)
        self.successful = [@record.valid?, @record.associated_valid?].all? {|v| v == true} # this syntax avoids a short-circuit
        if successful?
          @record.save! and @record.save_associated!
          after_update_save(@record)
        end
      end
    rescue ActiveRecord::RecordInvalid
    rescue ActiveRecord::StaleObjectError
      @record.errors.add_to_base as_("Version inconsistency - this record has been modified since you started editing it.")
      self.successful=false
    end
  end
end
