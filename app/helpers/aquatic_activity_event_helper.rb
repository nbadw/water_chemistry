module AquaticActivityEventHelper
  def start_date_column(aquatic_activity_event)
    aquatic_activity_event.start_date.to_s
  end

  def water_level_column(aquatic_activity_event)
    aquatic_activity_event.water_level ? aquatic_activity_event.water_level.observable_value.value : '-'
  end    
  
  def weather_conditions_column(aquatic_activity_event)
    aquatic_activity_event.weather_conditions ? aquatic_activity_event.weather_conditions.observable_value.value : '-'
  end
  
  def agency_site_id
    usage = controller.instance_variable_get(:@aquatic_site_usage)
    "Agency Site ID: #{(usage && !usage.agency_site_id.to_s.blank?) ? usage.agency_site_id : '-'}"
  end
  
  def agency_site_id_header_id
    "agency_site_id-#{aquatic_site_id}"
  end
  
  def edit_agency_site_id_link
    controller.active_scaffold_config.action_links['edit_agency_site_id']
  end
  
  def edit_agency_site_id_link?(link)
    link.action == edit_agency_site_id_link.action
  end
  
  def edit_agency_site_id_action_link_id
    action_link_id(:edit_agency_site_id, aquatic_site_id)     
  end
  
  def aquatic_site_id
    active_scaffold_session_storage = session["as:#{params[:eid]}"]
    if active_scaffold_session_storage && active_scaffold_session_storage[:constraints]
      active_scaffold_session_storage[:constraints][:aquatic_site_id]    
    end
  end
  
  def render_edit_agency_site_id_action_link(url_options)    
    link = edit_agency_site_id_link
    url_options = url_options.clone
    url_options[:action] = link.action
    url_options[:controller] = link.controller if link.controller
    url_options.delete(:search) if link.controller and link.controller.to_s != params[:controller]
    url_options.merge! link.parameters if link.parameters

    html_options = {:class => link.action}
    if link.inline?
      # NOTE this is in url_options instead of html_options on purpose. the reason is that the client-side
      # action link javascript needs to submit the proper method, but the normal html_options[:method]
      # argument leaves no way to extract the proper method from the rendered tag.
      url_options[:_method] = link.method

      if link.method != :get and respond_to?(:protect_against_forgery?) and protect_against_forgery?
        url_options[:authenticity_token] = form_authenticity_token
      end

      # robd: protect against submitting get links as forms, since this causes annoying 
      # 'Do you wish to resubmit your form?' messages whenever you go back and forwards.
    elsif link.method != :get
      # Needs to be in html_options to as the adding _method to the url is no longer supported by Rails
      html_options[:method] = link.method
    end

    html_options[:confirm] = link.confirm if link.confirm?
    html_options[:position] = link.position if link.position and link.inline?
    html_options[:class] += ' action' if link.inline?
    html_options[:popup] = true if link.popup?
    html_options[:id] = edit_agency_site_id_action_link_id
    html_options[:style] = 'display: none;' unless controller.instance_variable_get(:@aquatic_site_usage)

    if link.dhtml_confirm?
      html_options[:class] += ' action' if !link.inline?
      html_options[:page_link] = 'true' if !link.inline?
      html_options[:dhtml_confirm] = link.dhtml_confirm.value
      html_options[:onclick] = link.dhtml_confirm.onclick_function(controller,action_link_id(url_options[:action],url_options[:id]))
    end

    # issue 260, use url_options[:link] if it exists. This prevents DB data from being localized.
    label = url_options.delete(:link) || link.label
    link_to label, url_options, html_options
  end
end
