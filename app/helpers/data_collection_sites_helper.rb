module DataCollectionSitesHelper
  def incorporated_column(aquatic_site)    
    '<img class="incorporated" src="./images/lock_delete.png"/>' if aquatic_site.incorporated?
  end
  
  def water_body_name_column(aquatic_site)
    aquatic_site.waterbody ? aquatic_site.waterbody.water_body_name : '-'
  end
    
  def name_and_description_column(aquatic_site)
    description = [
      ("<span class=\"aquatic-site-name\">#{aquatic_site.name}</span>" if aquatic_site.name), 
      ("<span class=\"aquatic-site-description\">#{aquatic_site.description}</span>" if aquatic_site.description)
    ].compact.join('<br/>')       
    !description.empty? ? description : '-'
  end

  def coordinate_system_column(aquatic_site)
    aquatic_site.location.coordinate_system.display_name || '-'
  end
    
  def drainage_code_column(aquatic_site)
    return '-' unless aquatic_site.waterbody && aquatic_site.waterbody.drainage_unit
      
    waterbody, drainage_unit = aquatic_site.waterbody, aquatic_site.waterbody.drainage_unit      
    text_id, tooltip_id = "drainage_code-#{aquatic_site.id}", "tooltip_drainage_code-#{aquatic_site.id}"
      
    text = "<span id=\"#{text_id}\">#{waterbody.drainage_cd}</span>"
      
    tooltip = tag('div', {:id => tooltip_id, :class=>'tooltip', :style => 'display:none'}, true)
    tooltip << tag('div', {:id => "tooltip_content_#{tooltip_id}", :class=>'tooltip_content'}, true)
    tooltip << drainage_unit.explain_drainage_code   
    tooltip << '</div></div>'
      
    javascript = tag('script', { :type => 'text/javascript' }, true)
    javascript << "$('#{text_id}').observe('mouseover', function(evt) { $('#{tooltip_id}').show(); });"
    javascript << "$('#{text_id}').observe('mouseout',  function(evt) { $('#{tooltip_id}').hide(); });"
    javascript << '</script>'
      
    text + tooltip + tooltip_css + javascript
  end
    
  def agencies_column(record)      
    agency_site_id_hash = {}
    record.aquatic_site_usages.each do |aquatic_site_usage|
      if agency_cd = aquatic_site_usage.agency_cd      
        (agency_site_id_hash[agency_cd] ||= []) << aquatic_site_usage.agency_site_id unless aquatic_site_usage.agency_site_id.to_s.empty?
      end
    end

    creating_agency = User.find(record.created_by).agency rescue nil

    agencies = record.agencies.to_a
    agencies << creating_agency if creating_agency
    agencies = agencies.uniq

    agencies.collect do |agency|
      agency_site_ids = agency_site_id_hash[agency.id] || []
      site_id_text = "(" + agency_site_ids.uniq.join(', ') + ")" unless agency_site_ids.empty?
      ["#{agency.code}", site_id_text, "<br/>"]
    end.flatten.compact.join(' ')
  end
    
  def data_sets_column(aquatic_site)
    water_chemistry_sampling = AquaticActivity.find(17)
    attached_data_sets = aquatic_site.attached_data_sets.sort
    attached_data_sets.delete(water_chemistry_sampling)
      
    links = []
    ## initial link to water chemistry data
    links << water_chemistry_sampling_link(aquatic_site, water_chemistry_sampling)
            
    attached_data_sets.each do |aquatic_activity|
      link_text = "#{aquatic_activity.name} (#{AquaticActivityEvent.count_attached(aquatic_site, aquatic_activity)})"
      links << '<a href="#" class="attached-data-set disabled">' + link_text + '</a>'
    end
      
    links.join('<br/>')
  end
    
  def water_chemistry_sampling_link(aquatic_site, water_chemistry_sampling)      
    options = { 
      :_method => 'get', 
      :action => 'aquatic_site_activities',
      :aquatic_site_id => aquatic_site.id, 
      :controller => 'aquatic_activity_event',
      :aquatic_activity_id => water_chemistry_sampling.id, 
      :label => :water_chemistry_sampling_link_text.l_with_args({ :aquatic_site_id => aquatic_site.id, :aquatic_site_name => aquatic_site.name })
    }
    
    html_options = { 
      :class => 'nested action attached-data-set', 
      :position => 'after',
      :id => "aquatic_sites-nested-#{aquatic_site.id}-link", 
      :style => 'display: block;'         
    }
    
    count = AquaticActivityEvent.count_attached(aquatic_site, water_chemistry_sampling)
    link_to("#{water_chemistry_sampling.name} (#{count})", options, html_options)
  end
    
  def unattached_data_sets_select(unattached_data_sets)
    # TODO: eventually work in the other data sets and present in group -> name dropdown - e.g., options = unattached_data_sets.collect { |activity| [activity.name, activity.id] }
    water_chemistry_sampling = unattached_data_sets.find { |aquatic_activity| aquatic_activity.id == 17 }
    options = [water_chemistry_sampling].compact.collect { |aquatic_activity| [aquatic_activity.name, aquatic_activity.id] }
    select('aquatic_site', 'data_set', options)
  end
       
  def area_of_interest_toggle_link
    url = url_for(:controller => 'data_collection_sites', :action => 'toggle_area_of_interest')
    if current_user.area_of_interest
      link_to(area_of_interest_toggle_link_text, url,
        { 
          :id => area_of_interest_toggle_link_id, 
          :onclick => "doToggleAreaOfInterest('#{url}', '#{active_scaffold_content_id}', '#{active_scaffold_id}', 'data_collection_sites-table-loading-indicator');return false;"         
        }
      )  
    else
      "<a id=\"#{area_of_interest_toggle_link_id}\" class=\"disabled\">#{:aoi_disabled_text.l}</a>"
    end
  end
  
  def area_of_interest_toggle_link_text
    session[:filter_area_of_interest] ? :aoi_enabled_text.l : :aoi_disabled_text.l
  end
    
  def area_of_interest_toggle_link_id
    'area-of-interest-toggle'
  end
end
