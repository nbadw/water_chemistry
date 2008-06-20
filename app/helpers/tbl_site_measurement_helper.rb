module TblSiteMeasurementHelper
  def measurement_group_column(record)
    record.measurement_code.group || '-'
  end
end
