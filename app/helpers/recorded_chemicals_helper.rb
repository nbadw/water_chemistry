module RecordedChemicalsHelper
  def parameter_name_column(recorded_chemical)
    recorded_chemical.chemical.parameter    
  end
  
  def parameter_code_column(recorded_chemical)
    recorded_chemical.chemical.parameter_cd
  end
end
