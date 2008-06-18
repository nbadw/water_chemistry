module SampleResultsHelper
  def parameter_name_column(record)
    record.parameter.name
  end
  
  def parameter_code_column(record)
    record.parameter.code
  end 
end
