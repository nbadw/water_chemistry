module RecordedObservationsHelper
  def group_column(recorded_observation)
    recorded_observation.observation.group || '-'
  end
  
  def value_observed_column(recorded_observation)
    if recorded_observation.observable_value 
      value = recorded_observation.observable_value.value      
    else
      value = recorded_observation.value_observed
    end
    value || '-'
  end
  
  def fish_passage_obstruction_ind_column(record)
    if record.observation.fish_passage_ind
      return record.fish_passage_obstruction_ind ? 'Yes' : 'No'
    end

    '-'
  end
  
  def group(observations)    
    observations.collect{ |observation| observation.group.to_s }.uniq.sort
  end
  
  def option_group_for_observations(group, observations, selected_observation = nil)
    selected = selected_observation.id if selected_observation    
    optgroup = tag('optgroup', { :label => group }, true)
    optgroup << options_from_collection_for_select(observations_grouped_by(group, observations), :id, :name, selected)
    optgroup << '</optgroup>'
    optgroup
  end
  
  def observations_grouped_by(group, observations)
    observations.collect { |observation| observation if observation.group.to_s == group }.compact.sort_by { |observation| observation.name }
  end
  
  def value_observed_input(recorded_observation)
    if observation = recorded_observation.observation
      if observation.has_observable_values?
        '<select name="record[value_observed]">' + 
          options_from_collection_for_select(observation.observable_values, :id, :value, recorded_observation.value_observed) + 
        '</select>'
      else
        '<input name="record[value_observed]" type="text" class="text-input" value="' + recorded_observation.value_observed.to_s + '"/>'
      end
    end
  end
end
