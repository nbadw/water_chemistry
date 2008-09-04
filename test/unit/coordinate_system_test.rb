require File.dirname(__FILE__) + '/../test_helper'

class DummyCoordinateSystem < CoordinateSystem  
end

class CoordinateSystemTest < ActiveSupport::TestCase
  should "respond to :epsg and :name methods" do
    epsg, name = 1, 'Test Coordinate System'
    coordinate_system = CoordinateSystem.new(epsg, name)
    assert_equal epsg, coordinate_system.epsg
    assert_equal name, coordinate_system.name
  end
  
  should_have_class_methods :find, :all
end
