require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < ActiveSupport::TestCase
  context "a location object" do
    location = Location.new(1, 2, 3)
    methods = [:latitude, :longitude, :coordinate_system_id, :coordinate_system, :errors, :valid?, :blank?]
    for method in methods do
      should "have instance method #{method}" do
        assert location.respond_to?(method)
      end
    end
  end
  
  should "return coordinate system id when it matches an existing coordinate system" do
    location = Location.new(1, 2, 3)
    CoordinateSystem.expects(:find).with(location.coordinate_system_id).returns(CoordinateSystem.new)
    assert_not_nil location.coordinate_system
    assert_kind_of CoordinateSystem, location.coordinate_system
  end
  
  should "return nil when coordinate system id doesn't match any coordinate system" do
    location = Location.new(1, 2, 3)
    CoordinateSystem.expects(:find).with(location.coordinate_system_id).returns(nil)
    assert_nil location.coordinate_system
  end
  
  should "report blank if location is attributes are all nil" do
    assert Location.new(nil, nil, nil).blank?
  end
  
  should "not report blank if all required parameters are present" do
    assert !Location.new(1, 2, 3).blank?
  end
  
  should "report error on coordinate system id if it is nil" do
    location = Location.new(1, 2, nil)
    assert location.errors.empty?
    location.valid?
    assert location.errors.invalid?(:coordinate_system_id)
  end
  
  should "report error on coordinate system id if it doesn't correspond to an exist coordinate system" do     
    location = Location.new(1, 2, 3)
    CoordinateSystem.expects(:exists?).with(location.coordinate_system_id).returns(false)    
    assert location.errors.empty?
    location.valid?
    assert location.errors.invalid?(:coordinate_system_id)    
  end
  
  should "not report errors on coordinate system id if it is valid" do
    location = Location.new(1, 2, 3)
    CoordinateSystem.expects(:exists?).with(location.coordinate_system_id).returns(true)
    assert location.errors.empty?
    location.valid?
    assert_nil location.errors.on(:coordinate_system_id)
  end
end
