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
  
  should "return actual coordinate system if it matches an existing coordinate system by name or id" do
    location = Location.new(1, 2, 3)
    coordinate_system = mock
    CoordinateSystem.expects(:find).with(location.coordinate_system_id).returns(coordinate_system)
    assert_not_nil location.coordinate_system
  end
  
  should "return nil when coordinate system id doesn't match any coordinate system" do
    location = Location.new(1, 2, 3)
    CoordinateSystem.expects(:find).with(location.coordinate_system_id).returns(nil)
    assert_nil location.coordinate_system
  end
  
  should "report blank if location is attributes are all blank" do
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
    assert_match(/blank/, location.errors.on(:coordinate_system_id))
  end
  
  should "report error on coordinate system id if it doesn't correspond to an existing coordinate system" do     
    location = Location.new(1, 2, 3)
    CoordinateSystem.expects(:find).with(location.coordinate_system_id).returns(nil)    
    assert location.errors.empty?
    location.valid?
    assert location.errors.invalid?(:coordinate_system_id)   
    assert_match(/not found/, location.errors.on(:coordinate_system_id))
  end
  
  should "not report errors on coordinate system id if it is valid" do
    location = Location.new(1, 2, 3)
    coordinate_system = mock(:nil? => false)
    CoordinateSystem.expects(:find).with(location.coordinate_system_id).returns(coordinate_system)
    assert location.errors.empty?
    location.valid?
    assert_nil location.errors.on(:coordinate_system_id)
  end
  
  should "report validation errors on latitude" do
    CoordinateSystem.stubs(:exists?).returns(true)
    
    location = Location.new(nil, 2, 3)    
    location.valid?    
    assert location.errors.invalid?(:latitude)
    assert_match(/blank/, location.errors.on(:latitude))
    
    location = Location.new('bad format', 2, 3)    
    location.valid?
    assert location.errors.invalid?(:latitude)
    assert_match(/bad format/, location.errors.on(:latitude))
  end
  
  should "report validation errors on longitude" do
    CoordinateSystem.stubs(:exists?).returns(true)
    
    location = Location.new(1, nil, 3)    
    location.valid?    
    assert location.errors.invalid?(:longitude)
    assert_match(/blank/, location.errors.on(:longitude))
    
    location = Location.new(1, 'bad format', 3)    
    location.valid?
    assert location.errors.invalid?(:longitude)
    assert_match(/bad format/, location.errors.on(:longitude))
  end
  
  should "accept degrees minutes seconds format for latitude and longitude coordinates" do
    possible_formats = [
      ["40:26:46.302N", "79:56:55.903W"],
      ["40°26'21\"N", "79°58'36\"W"],
      ["40d26'21\"N", "79d58'36\"W"]
    ]
    possible_formats.each do |coordinates|
      latitude, longitude = coordinates
      location = Location.new(latitude, longitude, nil)
      location.valid?
      assert_nil location.errors.on(:latitude)
      assert_nil location.errors.on(:longitude)
      # and the negative versions of the coordinates...
      location = Location.new('-' + latitude, '-' + longitude, nil)
      location.valid?
      assert_nil location.errors.on(:latitude)
      assert_nil location.errors.on(:longitude)
    end
  end
  
  should "accept decimal format for latitude and longitude coordinates" do
    latitude, longitude = 40.446195, 79.948862
    location = Location.new(latitude, longitude, nil)
    location.valid?
    assert_nil location.errors.on(:latitude)
    assert_nil location.errors.on(:longitude)
    # and the negative versions of the coordinates...
    location = Location.new(-1.0 * latitude, -1.0 * longitude, nil)
    location.valid?
    assert_nil location.errors.on(:latitude)
    assert_nil location.errors.on(:longitude)
  end
end
