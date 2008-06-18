require File.dirname(__FILE__) + '/../test_helper'

class SampleResultTest < ActiveSupport::TestCase
  should_belong_to :parameter, :sample
  should_require_attributes :parameter, :sample, :value
  
  context "with an existing record" do
    setup { SampleResult.generate! }
    should_require_unique_attributes :parameter_id, :scoped_to => :sample_id
  end
end
