module AquaticSiteHelper
  def incorporated_column(record)    
    '<img class="incorporated" src="/images/lock_delete.png"/>' if record.incorporated?
  end
  
  def agencies_column(record)
    agency_site_id_hash = {}
    record.aquatic_site_usages.each do |aquatic_site_usage|
      if agency_id = aquatic_site_usage.agency_id      
        (agency_site_id_hash[agency_id] ||= []) << aquatic_site_usage.agency_site_id unless aquatic_site_usage.agency_site_id.to_s.empty?
      end
    end
    
    record.agencies.collect do |agency|      
      agency_site_ids = agency_site_id_hash[agency.id] || []
      site_id_text = "(" + agency_site_ids.uniq.join(', ') + ")" unless agency_site_ids.empty?
      ["#{agency.code}", site_id_text, "<br/>"]
    end.flatten.compact.join(' ')
  end
  
  def waterbody_name_column(record)
    name = record.waterbody ? record.waterbody.name : '-'
    name.to_s.empty? ? '-' : name
  end
  
  def name_and_description_column(record)
    description = [
      ("<span class=\"aquatic-site-name\">#{record.name}</span>" if record.name), 
      ("<span class=\"aquatic-site-description\">#{record.description}</span>" if record.description)
    ].compact.join('<br/>')       
    !description.empty? ? description : '-'
  end
  
  def aquatic_activities_column(record)
    options = { :_method => 'get', :action => 'aquatic_site_activities',
      :aquatic_site_id => record.id, :controller => 'aquatic_activity_event' }
    
    html_options = { :class => 'nested action', :position => 'after',
      :id => "aquatic_sites-nested-#{record.id}-link" }
    
    # create links to inline site activities
    links = record.aquatic_activities.sort.collect do |aquatic_activity|      
      options[:aquatic_activity_id] = aquatic_activity.id
      options[:label] = "#{aquatic_activity.name} for Site ##{record.id} - #{record.name}"
      # XXX: limiting to only water chemistry sampling activities, the rest are disabled
      if aquatic_activity.name == 'Water Chemistry Sampling'
        link_to aquatic_activity.name, options, html_options
      else
        '<a href="#" class="disabled">' + aquatic_activity.name + '</a>'
      end
    end
    
    # create default link to create a new activity
    links << link_to('Add a new data set', { :_method => 'get', :controller => 'aquatic_site_usage',
      :action => 'new', :aquatic_site_id => record.id, :format => 'js' }, { :class => 'nested action', 
      :position => 'after', :id => "aquatic_sites-nested-#{record.id}-link" })
    
    links.join('<br/><br/>')
  end
  
  def coordinates_column(record)
    "--- TODO ---"
  end
end
