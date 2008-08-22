# == Schema Information
# Schema version: 1
#
# Table name: water_chemistry_sample_results
#
#  id                           :integer(11)     not null, primary key
#  water_chemistry_sample_id    :integer(11)     
#  water_chemistry_parameter_id :integer(11)     
#  instrument_id                :integer(11)     
#  unit_of_measure_id           :integer(11)     
#  value                        :float           
#  qualifier                    :string(255)     
#  comment                      :string(255)     
#

class WaterChemistrySampleResult < ActiveRecord::Base
  belongs_to :water_chemistry_parameter
  belongs_to :water_chemistry_sample
  
  validates_presence_of   :water_chemistry_parameter, :water_chemistry_sample, :value
  validates_uniqueness_of :water_chemistry_parameter_id, :scope => :water_chemistry_sample_id
  
  def parameter_name
    water_chemistry_parameter.display_name
  end
end
