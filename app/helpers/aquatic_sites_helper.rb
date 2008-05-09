module AquaticSitesHelper  
  def description_column(record)
    record.description || 'No Description'
  end
  
  def agencies_column(record)
    record.agencies.join(', ')
  end
end
