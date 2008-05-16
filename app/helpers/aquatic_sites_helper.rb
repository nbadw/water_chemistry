module AquaticSitesHelper  
  def description_column(record)
    record.description || 'No Description'
  end
  
  def agencies_column(record)
    record.agencies.join(', ')
  end
  
  def activities_column(record)
    options = {
      :_method => 'get',
      :action => 'site_activity_usages',
      :aquatic_site_id => record.id,
      :controller => 'aquatic_site_usages'      
    }
    html_options = {
      :class => 'nested action',
      :position => 'after',
      :id => "aquatic_sites-nested-#{record.id}-link"
    }
    
    record.activities.collect do |activity|
      options[:activity_id] = activity.id
      options[:label] = "#{activity.name} Activities for #{record.name}"
      link_to activity.name, options, html_options
    end.join('<br/><br/>')
  end
end
