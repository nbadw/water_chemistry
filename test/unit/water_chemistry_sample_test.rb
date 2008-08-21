require File.dirname(__FILE__) + '/../test_helper'

class WaterChemistrySampleTest < ActiveSupport::TestCase
  should_belong_to :aquatic_activity_event
  should_have_many :water_chemistry_sample_results
  should_have_many :water_chemistry_parameters, :through => :water_chemistry_sample_results
  
  context "with an existing record" do
    setup do
      @water_chemistry_sample = WaterChemistrySample.generate!
    end
    
    should_allow_values_for :sample_collection_method, *WaterChemistrySample.sample_collection_methods
  end
end
