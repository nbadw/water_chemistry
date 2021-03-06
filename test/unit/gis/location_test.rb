require File.dirname(__FILE__) + '/../../test_helper'

class LocationTest < ActiveSupport::TestCase
  context "a location object" do
    location = Location.new(1, 2, 'CoordSystem')
    methods = [:latitude, :longitude, :coordinate_system_name, :coordinate_system, :errors, :valid?, :blank?]
    for method in methods do
      should "have instance method #{method}" do
        assert location.respond_to?(method)
      end
    end
  end
  
  should "return actual coordinate system if it matches an existing coordinate system by name" do
    location = Location.new(1, 2, 'CoordSystem')
    coordinate_system = mock
    CoordinateSystem.expects(:find_by_display_name).with(location.coordinate_system_name).returns(coordinate_system)
    assert_not_nil location.coordinate_system
  end
  
  should "return nil when coordinate system id doesn't match any coordinate system" do
    location = Location.new(1, 2, 'CoordSystem')
    CoordinateSystem.expects(:find_by_display_name).with(location.coordinate_system_name).returns(nil)
    assert_nil location.coordinate_system
  end
  
  should "report blank if location is attributes are all blank" do
    assert Location.new(nil, nil, nil).blank?
  end
  
  should "not report blank if all required parameters are present" do
    assert !Location.new(1, 2, 'CoordSystem').blank?
  end
  
  should "report error on coordinate system id if it is nil" do
    location = Location.new(1, 2, nil)
    assert location.errors.empty?
    location.valid?
    assert location.errors.invalid?(:coordinate_system)
    assert_match(/blank/, location.errors.on(:coordinate_system))
  end
  
  should "report error on coordinate system id if it doesn't correspond to an existing coordinate system" do     
    location = Location.new(1, 2, 'CoordSystem')
    CoordinateSystem.expects(:find_by_display_name).with(location.coordinate_system_name).returns(nil)    
    assert location.errors.empty?
    location.valid?
    assert location.errors.invalid?(:coordinate_system)   
    assert_match(/not found/, location.errors.on(:coordinate_system))
  end
  
  should "not report errors on coordinate system id if it is valid" do
    location = Location.new(1, 2, 'CoordSystem')
    coordinate_system = mock(:nil? => false)
    CoordinateSystem.expects(:find_by_display_name).with(location.coordinate_system_name).returns(coordinate_system)
    assert location.errors.empty?
    location.valid?
    assert_nil location.errors.on(:coordinate_system)
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
      ["40d26'21\"N", "79d58'36\"W"],
      ["67 26 46.302", "40 56 55.903"]
    ]
    possible_formats.each do |coordinates|
      latitude, longitude = coordinates
      location = Location.new(latitude, longitude, nil)
      location.valid?
      assert_nil location.errors.on(:latitude), "latitude: #{latitude} should be valid"
      assert_nil location.errors.on(:longitude), "longitude: #{longitude} should be valid"
      # and the negative versions of the coordinates...
      location = Location.new('-' + latitude, '-' + longitude, nil)
      location.valid?
      assert_nil location.errors.on(:latitude), "latitude: -#{latitude} should be valid"
      assert_nil location.errors.on(:longitude), "longitude: -#{longitude} should be valid"
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

  should "not accept invalid decimal numbers" do
    invalid = [
      "040.446195",
      "-01.2345",
      "0-23.33421"
    ]
    invalid.each do |lat|
      location = Location.new(lat, 0, nil)
      location.valid?
      assert location.errors.on(:latitude), "#{lat} should be invalid"
    end
  end

  should "accept valid decimal numbers" do
    valid = [
      "40.446195",
      "-23.33421",
      "0",
      "0.0",
      "0.001",
      "-0.123",
      "123",
      "-65"
    ]
    valid.each do |lat|
      location = Location.new(lat, 0, nil)
      location.valid?
      assert_nil location.errors.on(:latitude), "#{lat} should be valid"
    end
  end
end
