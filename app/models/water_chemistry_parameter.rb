class WaterChemistryParameter < ActiveRecord::Base 
  has_many :water_chemistry_sample_results  
  validates_presence_of :name, :code
end
