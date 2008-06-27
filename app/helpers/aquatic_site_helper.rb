module AquaticSiteHelper
  def incorporated_column(record)
    '<img class="incorporated" src="' + (record.incorporated? ? '/images/lock.png' : '/images/lock_open.png') +  '"/>' 
  end
  
  def agencies_column(record)
    record.agencies.collect { |agency| agency.code }.uniq.sort.join('<br/><br/>')
  end
  
  def waterbody_name_column(record)
    name = record.waterbody ? record.waterbody.name : '-'
    name.to_s.empty? ? '-' : name
  end
  
  def description_column(record)
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
      options[:label] = "#{aquatic_activity.name} Activities for #{record.name}"
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
