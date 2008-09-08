require File.dirname(__FILE__) + '/../../test_helper'

class CoordinateSourceTest < ActiveSupport::TestCase
  should "respond to :id and :name methods" do
    id, name = 1, 'Test Coordinate Source'
    coordinate_source = CoordinateSource.new(id, name)
    assert_equal id, coordinate_source.id
    assert_equal name, coordinate_source.name
  end
  
  should_have_class_methods :find, :all
end
