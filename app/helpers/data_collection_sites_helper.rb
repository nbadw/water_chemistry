module DataCollectionSitesHelper
  def incorporated_column(aquatic_site)    
      '<img class="incorporated" src="/images/lock_delete.png"/>' if aquatic_site.incorporated?
    end
    
    def name_and_description_column(aquatic_site)
      description = [
        ("<span class=\"aquatic-site-name\">#{aquatic_site.name}</span>" if aquatic_site.name), 
        ("<span class=\"aquatic-site-description\">#{aquatic_site.description}</span>" if aquatic_site.description)
      ].compact.join('<br/>')       
      !description.empty? ? description : '-'
    end
    
    def drainage_code_column(aquatic_site)
      drainage_code = aquatic_site.waterbody.drainage_cd if aquatic_site.waterbody
      drainage_code || '-'
    end
    
    def agencies_column(record)      
      agency_site_id_hash = {}
      record.aquatic_site_usages.each do |aquatic_site_usage|
        if agency_cd = aquatic_site_usage.agency_cd      
          (agency_site_id_hash[agency_cd] ||= []) << aquatic_site_usage.agency_site_id unless aquatic_site_usage.agency_site_id.to_s.empty?
        end
      end
    
      record.agencies.uniq.collect do |agency|      
        agency_site_ids = agency_site_id_hash[agency.id] || []
        site_id_text = "(" + agency_site_ids.uniq.join(', ') + ")" unless agency_site_ids.empty?
        ["#{agency.code}", site_id_text, "<br/>"]
      end.flatten.compact.join(' ')
    end
    
    def aquatic_activities_column(aquatic_site)
      attached_data_sets = aquatic_site.attached_data_sets.sort
      
      options = { :_method => 'get', :action => 'aquatic_site_activities',
        :aquatic_site_id => aquatic_site.id, :controller => 'aquatic_activity_event' }
    
      html_options = { :class => 'nested action attached-data-set', :position => 'after',
        :id => "aquatic_sites-nested-#{aquatic_site.id}-link" }
    
      # create links to inline site activities
      links = attached_data_sets.collect do |aquatic_activity|      
        options[:aquatic_activity_id] = aquatic_activity.id
        options[:label] = "#{aquatic_activity.name} for Site ##{aquatic_site.id} - #{aquatic_site.name}"
        # TODO: limiting to only water chemistry sampling activities, the rest are disabled (this should be in model)
        if aquatic_activity.name == 'Water Chemistry Sampling'
          link_to aquatic_activity.name, options, html_options
        else
          '<a href="#" class="attached-data-set disabled">' + aquatic_activity.name + '</a>'
        end
      end
    
      # default link to create a new activity
      links << link_to('Add a new data set', { :action => 'add_data_set', :aquatic_site_id => aquatic_site.id, :format => 'js' }, 
        { :class => 'nested action', :position => 'after', :id => "aquatic_sites-nested-#{aquatic_site.id}-link" })
      # TODO: make this a popup instead of an inline action
    
      links.join('<br/>')
    end
end
