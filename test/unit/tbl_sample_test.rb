require File.dirname(__FILE__) + '/../test_helper'

class TblSampleTest < ActiveSupport::TestCase
  should_belong_to :aquatic_activity
  should_have_many :sample_results
  should_have_many :parameters, :through => :sample_results
  
  context "with an existing record" do
    setup do
      @tbl_sample = TblSample.generate!
    end
    
    should_allow_values_for :collection_method, TblSample.collection_method_options
  end
end
