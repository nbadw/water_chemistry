class WaterChemistrySampleResult < ActiveRecord::Base
  belongs_to :water_chemistry_parameter
  belongs_to :water_chemistry_sample
  
  validates_presence_of   :water_chemistry_parameter, :water_chemistry_sample, :value
  validates_uniqueness_of :water_chemistry_parameter_id, :scope => :water_chemistry_sample_id
  
  def to_label
    'Parameter'
  end
end
