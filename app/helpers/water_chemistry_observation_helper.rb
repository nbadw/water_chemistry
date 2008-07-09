module WaterChemistryObservationHelper
  def group_column(record)
    record.observation.grouping
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
end
