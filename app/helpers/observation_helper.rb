module ObservationHelper
  def observation_group_column(record)
    record.observation.grouping || '-'
  end
  
  def fish_passage_blocked_column(record)
    if record.observation.fish_passage_blocked_observation?
      return record.fish_passage_blocked? ? 'Yes' : 'No'
    end

    '-'
  end
  
  def groups(observations)    
    observations.collect{ |observation| observation.grouping.to_s }.uniq.sort
  end
  
  def observations_grouped_by(group, observations)
    observations.collect { |observation| observation if observation.grouping.to_s == group }.compact.sort_by { |observation| observation.name }
  end
  
  def value_observed_input(site_observation)
    if observation = site_observation.observation
      if observation.has_observable_values?
        '<select name="record[value_observed]">' + 
          options_from_collection_for_select(observation.observable_values, :value, :value, site_observation.value_observed) + 
        '</select>'
      else
        '<input name="record[value_observed]" type="text" class="text-input" value="' + site_observation.value_observed.to_s + '"/>'
      end
    end
  end
end
