module RecordedObservationsHelper
  def observation_group_column(record)
    record.observation.group || '-'
  end
  
  def fish_passage_blocked_column(record)
    if record.observation.fish_passage_blocked_observation?
      return record.fish_passage_blocked? ? 'Yes' : 'No'
    end

    '-'
  end
  
  def group(observations)    
    observations.collect{ |observation| observation.group.to_s }.uniq.sort
  end
  
  def option_group_for_observations(group, observations, selected_observation = nil)
    selected = selected_observation.id if selected_observation
    optgroup = tag('optgroup', { :label => group.blank? ? 'Misc.' : group }, true)
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
          options_from_collection_for_select(observation.observable_values, :value, :value, recorded_observation.value_observed) + 
        '</select>'
      else
        '<input name="record[value_observed]" type="text" class="text-input" value="' + recorded_observation.value_observed.to_s + '"/>'
      end
    end
  end
end
