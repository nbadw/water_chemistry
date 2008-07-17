require File.dirname(__FILE__) + '/../test_helper'

class WaterChemistrySampleResultTest < ActiveSupport::TestCase
  should_belong_to :water_chemistry_parameter, :water_chemistry_sample
  should_require_attributes :water_chemistry_parameter, :water_chemistry_sample, :value
  
  context "with an existing record" do
    setup { WaterChemistrySampleResult.generate! }
    should_require_unique_attributes :water_chemistry_parameter_id, :scoped_to => :water_chemistry_sample_id
  end
end
