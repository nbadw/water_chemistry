module TblObservationHelper
  def observation_group_column(record)
    record.observation_code.group || '-'
  end
end
