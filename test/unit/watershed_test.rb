require File.dirname(__FILE__) + '/../test_helper'

class WatershedTest < ActiveSupport::TestCase
  should_have_many :waterbodies
  should_require_attributes :drainage_code
  
  context "given an existing record" do
    setup do
      @watershed = Watershed.generate
    end
    
    should_require_unique_attributes :drainage_code 
  end
end
