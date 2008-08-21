# == Schema Information
# Schema version: 2
#
# Table name: water_chemistry_parameters
#
#  id          :integer(11)     not null, primary key
#  name        :string(255)     
#  code        :string(255)     
#  created_at  :datetime        
#  updated_at  :datetime        
#  imported_at :datetime        
#  exported_at :datetime        
#

class WaterChemistryParameter < ActiveRecord::Base 
  has_many :water_chemistry_sample_results  
  validates_presence_of :name, :code
  
  def display_name
    "#{name} (#{code})"
  end
end
