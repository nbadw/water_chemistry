module AquaticActivityEventHelper
  def start_date_column(record)
    record.start_date.to_s(:adw)
  end
end
