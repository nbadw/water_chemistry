class AquaticActivityEventController < ApplicationController  
  before_filter :login_required
  before_filter :find_aquatic_activity_methods, :only => [:new, :create, :edit, :update]
  before_filter :find_aquatic_site_usage, :only => [:list, :table, :edit_agency_site_id, :update_agency_site_id]
  
  active_scaffold do |config|
    # base config 
    config.label = :aquatic_activity_event_label.l
    config.actions = [:create, :list, :show, :update, :delete, :nested, :subform]

    config.columns = [:aquatic_site_id, :aquatic_activity_cd, :aquatic_activity_method, :start_date, :agency, :weather_conditions, :water_level]
    config.list.columns = [:aquatic_activity_method, :start_date, :agency, :weather_conditions, :water_level]
    config.show.columns = [:aquatic_activity_method, :start_date, :agency, :weather_conditions, :water_level]
        
    config.columns[:aquatic_site_id].search_sql = "#{AquaticActivityEvent.table_name}.#{AquaticActivityEvent.column_for_attribute(:aquatic_site_id).name}"    
    config.columns[:aquatic_activity_cd].search_sql = "#{AquaticActivityEvent.table_name}.#{AquaticActivityEvent.column_for_attribute(:aquatic_activity_cd).name}"

    # i18n labels
    config.columns[:aquatic_site_id].label         = :aquatic_site_id_label.l
    config.columns[:aquatic_activity_cd].label     = :aquatic_activity_cd_label.l
    config.columns[:aquatic_activity_method].label = :aquatic_activity_method_label.l
    config.columns[:start_date].label              = :start_date_label.l
    config.columns[:weather_conditions].label      = :weather_conditions_label.l
    config.columns[:water_level].label             = :water_level_label.l
    config.columns[:agency].label                  = :agency_label.l

    # action link labels
    config.create.label    = :aquatic_activity_event_create_label.l 
    config.update.label    = :aquatic_activity_event_update_label.l 
    config.show.link.label = :aquatic_activity_event_show_label.l 

    # descriptions
    config.columns[:aquatic_activity_method].description = :aquatic_activity_method_desc.l
    
    # required fields
    config.columns[:aquatic_activity_method].required = true
    config.columns[:start_date].required = true
    
    # list config    
    config.columns[:start_date].sort_by :method => "#{self.name}.to_s"    
    config.list.sorting = [{ :start_date => :desc }]

    # show config
    config.show.link.inline = false
    config.show.link.controller = 'water_chemistry_sampling'
    config.show.link.action = 'samples'
    # XXX: added so this action can be overridden in helper
    config.show.link.parameters = { :water_chemistry_sampling_link => true }

    # remove agency association auto-link
    config.columns[:agency].clear_link

    # link to allow adding/editing of an agency's site id
    config.action_links.add 'edit_agency_site_id', 
      :label => :edit_agency_site_id_label.l,
      :type => :table,
      :inline => true
  end
  
  def show
    event = AquaticActivityEvent.find params[:id], :include => :aquatic_activity
    activity_name = event.aquatic_activity.name
    activity_controller = activity_name.gsub(' ', '_').downcase
    redirect_to :controller => activity_controller, :action => 'samples', 
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
      flash[:error] = :blank_agency_site_id_error.l # "Agency Site ID can't be blank"
    else      
      @aquatic_site_usage.agency_site_id = new_agency_site_id
      flash[:error] = @aquatic_site_usage.errors.full_messages.to_sentence unless @aquatic_site_usage.save
    end
  end
  
  protected  
  def before_create_save(aquatic_activity_event)  
    aquatic_activity_event.aquatic_site_id = active_scaffold_session_storage[:constraints][:aquatic_site_id]
    aquatic_activity_event.aquatic_activity_cd = active_scaffold_session_storage[:constraints][:aquatic_activity_cd].to_i
    aquatic_activity_event.agency_cd = current_user.agency.id
  end
  
  def after_create_save(aquatic_activity_event)
    maybe_create_aquatic_site_usage
  end
  
  def do_destroy
    super
    maybe_destroy_aquatic_site_usage if self.send(:successful?)
  end
    
  def maybe_create_aquatic_site_usage
    return if find_aquatic_site_usage      
    @aquatic_site_usage = AquaticSiteUsage.create({ :agency_cd => current_user.agency.id }.merge(active_scaffold_session_storage[:constraints]))
  end
  
  def maybe_destroy_aquatic_site_usage
    constraints = active_scaffold_session_storage[:constraints]
    if AquaticActivityEvent.count_attached(constraints[:aquatic_site_id], constraints[:aquatic_activity_cd]) == 0
      usage = find_aquatic_site_usage
      usage.destroy
      @aquatic_site_usage = nil
    end
  end
    
  def find_aquatic_activity_methods
    @aquatic_activity_methods = AquaticActivityMethod.find(:all,
      :conditions => [
        "#{AquaticActivityMethod.column_for_attribute(:aquatic_activity_cd).name} = ?", 
        active_scaffold_session_storage[:constraints][:aquatic_activity_cd]        
      ]
    )
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
