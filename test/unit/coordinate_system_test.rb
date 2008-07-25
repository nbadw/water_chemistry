require File.dirname(__FILE__) + '/../test_helper'

class DummyCoordinateSystem < CoordinateSystem  
end

class CoordinateSystemTest < ActiveSupport::TestCase
  should_require_attributes :epsg, :name
  
  context "with an existing record" do 
    setup { DummyCoordinateSystem.generate! }
    
    should_require_unique_attributes :epsg
    should_only_allow_numeric_values_for :epsg
  end
end
