module AquaticActivityEventHelper
  def start_date_column(aquatic_activity_event)
    aquatic_activity_event.start_date.to_s
  end

  def water_level_column(aquatic_activity_event)
    aquatic_activity_event.water_level ? aquatic_activity_event.water_level.observable_value.value : '-'
  end    
  
  def weather_conditions_column(aquatic_activity_event)
    aquatic_activity_event.weather_conditions ? aquatic_activity_event.weather_conditions.observable_value.value : '-'
  end
end
