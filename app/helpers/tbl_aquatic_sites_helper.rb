module TblAquaticSitesHelper
  def description_column(record)
    record.description || 'No Description'
  end
  
  def aquatic_activity_codes_column(record)
    options = {
      :_method => 'get',
      :action => 'aquatic_site_activities',
      :aquatic_site_id => record.id,
      :controller => 'tbl_aquatic_activity'      
    }
    html_options = {
      :class => 'nested action',
      :position => 'after',
      :id => "aquatic_sites-nested-#{record.id}-link"
    }
    
    record.aquatic_activity_codes.uniq.collect do |aquatic_activity_code|      
      options[:aquatic_activity_code] = aquatic_activity_code.id
      options[:label] = "#{aquatic_activity_code.name} Activities for #{record.name}"
      # XXX: limiting to only water chemistry sampling activities, the rest are disabled
      if aquatic_activity_code.name == 'Water Chemistry Sampling'
        link_to aquatic_activity_code.name, options, html_options
      else
        '<a href="#" class="disabled">' + aquatic_activity_code.name + '</a>'
      end
    end.join('<br/><br/>')
  end
end
