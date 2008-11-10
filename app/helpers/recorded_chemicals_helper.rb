module RecordedChemicalsHelper
  def parameter_name_column(recorded_chemical)
    recorded_chemical.chemical.parameter    
  end
  
  def parameter_code_column(recorded_chemical)
    recorded_chemical.chemical.parameter_cd
  end
  
  def unit_of_measure_column(recorded_chemical)
    recorded_chemical.unit_of_measure ? recorded_chemical.unit_of_measure.name_and_unit : '-'
  end
end
