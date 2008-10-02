class AquaticActivityEventController < ApplicationController  
  before_filter :find_aquatic_activity_methods, :only => [:new, :create]
  before_filter :find_aquatic_site_usage, :only => [:list, :table, :edit_agency_site_id, :update_agency_site_id]
  before_filter :update_edit_agency_site_id_label, :only => [:list, :table, :edit_agency_site_id]  
  
  active_scaffold do |config|
    # base config 
    config.label = "Aquatic Activities"
    config.actions.exclude :search
    
    config.columns = [:aquatic_site_id, :aquatic_activity_cd, :aquatic_activity_method, :start_date, :agency, :weather_conditions, :water_level]
    config.list.columns = [:aquatic_activity_method, :start_date, :agency, :weather_conditions, :water_level]
    config.show.columns = [:aquatic_activity_method, :start_date, :agency, :weather_conditions, :water_level]
        
    config.columns[:aquatic_site_id].search_sql = "#{AquaticActivityEvent.table_name}.#{AquaticActivityEvent.column_for_attribute(:aquatic_site_id).name}"    
    config.columns[:aquatic_activity_cd].search_sql = "#{AquaticActivityEvent.table_name}.#{AquaticActivityEvent.column_for_attribute(:aquatic_activity_cd).name}"
   
    config.columns[:aquatic_activity_method].label = "Analysis Method"
    config.columns[:start_date].label = "Date"
    config.columns[:weather_conditions].label = "Weather Conditions"
    config.columns[:water_level].label = "Water Level"
    
    # list config    
    config.columns[:start_date].sort_by :method => "#{self.name}.to_s"    
    config.list.sorting = [{ :start_date => :desc }]
    
    config.update.link.inline = false
    config.show.link.inline = false
    config.action_links.add 'edit_agency_site_id', :label => 'Edit Agency Site ID', :type => :table, :inline => true
  end
  
  def edit
    event = AquaticActivityEvent.find params[:id], :include => :aquatic_activity
    activity_name = event.aquatic_activity.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'edit', 
      :aquatic_activity_event_id => event.id, :aquatic_site_id => event.aquatic_site_id
  end
  
  def show
    event = AquaticActivityEvent.find params[:id], :include => :aquatic_activity
    activity_name = event.aquatic_activity.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'edit', 
      :aquatic_activity_event_id => event.id, :aquatic_site_id => event.aquatic_site_id
  end
  
  def aquatic_site_activities    
    @label = params[:label]       
    @constraints = { :aquatic_site_id => params[:aquatic_site_id], :aquatic_activity_cd => params[:aquatic_activity_id] }  
    render :layout => false
  end
  
  def details
    @record = AquaticActivityEvent.find params[:aquatic_activity_event_id] 
    render :action => 'show', :layout => false
  end
  
  def edit_agency_site_id
    render(:partial => 'edit_agency_site_id_form', :layout => false)
  end
  
  def update_agency_site_id
    new_agency_site_id = params[:agency_site_id]
    if new_agency_site_id.to_s.empty?
      flash[:error] = "Agency Site ID can't be blank"
    else      
      @aquatic_site_usage.agency_site_id = new_agency_site_id
      flash[:error] = @aquatic_site_usage.errors.full_messages.to_sentence unless @aquatic_site_usage.save
    end
    update_edit_agency_site_id_label
  end
  
  protected  
  def before_create_save(aquatic_activity_event)
    aquatic_activity_event.water_level = nil
    aquatic_activity_event.weather_conditions = nil    
    aquatic_activity_event.aquatic_site_id = active_scaffold_session_storage[:constraints][:aquatic_site_id]
    aquatic_activity_event.aquatic_activity_cd = active_scaffold_session_storage[:constraints][:aquatic_activity_cd].to_i
    aquatic_activity_event.agency_cd = current_user.agency.id
  end
  
  def after_create_save(aquatic_activity_event)
    maybe_create_water_observations(aquatic_activity_event)
    maybe_create_aquatic_site_usage(aquatic_activity_event)
  end
  
  def maybe_create_water_observations(aquatic_activity_event)
    weather_conditions = params[:record][:weather_conditions]
    unless weather_conditions.to_s.empty?
      rec_obs = RecordedObservation.new(:aquatic_activity_event => aquatic_activity_event, :observation => Observation.weather_conditions)
      rec_obs.value_observed = weather_conditions
      rec_obs.save!
    end
    
    water_level = params[:record][:water_level]
    unless water_level.to_s.empty?
      rec_obs = RecordedObservation.new(:aquatic_activity_event => aquatic_activity_event, :observation => Observation.water_level)
      rec_obs.value_observed = water_level
      rec_obs.save!
    end
  end
  
  def maybe_create_aquatic_site_usage(aquatic_activity_event)
    return if find_aquatic_site_usage      
    AquaticSiteUsage.create({ :agency_cd => current_user.agency.id }.merge(active_scaffold_session_storage[:constraints]))
  end
    
  def find_aquatic_activity_methods
    @aquatic_activity_methods = AquaticActivityMethod.find(:all,
      :conditions => [
        "#{AquaticActivityMethod.column_for_attribute(:aquatic_activity_cd).name} = ?", 
        active_scaffold_session_storage[:constraints][:aquatic_activity_cd]        
      ]
    )
  end
  
  def update_edit_agency_site_id_label
    if @aquatic_site_usage
      active_scaffold_config.action_links['edit_agency_site_id'].label = @aquatic_site_usage.agency_site_id ? 'Edit Agency Site ID' : 'Add Agency Site ID'
    end
  end
  
  def find_aquatic_site_usage    
    options = { :agency_cd => current_user.agency.id }.merge(active_scaffold_session_storage[:constraints])
    conditions = []
    
    options.each do |attr, value|
      query = conditions.first || []
      query << "#{AquaticSiteUsage.column_for_attribute(attr).name} = ?"
      conditions[0] = query
      conditions << value
    end
    conditions[0] = conditions.first.join(' AND ')
    
    @aquatic_site_usage = AquaticSiteUsage.first(:conditions => conditions)
    @aquatic_site_usage    
  end
end
