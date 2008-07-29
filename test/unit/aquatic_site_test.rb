require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class AquaticSiteTest < ActiveSupport::TestCase
  should_belong_to :waterbody, :coordinate_source 
  should_have_many :aquatic_site_usages
  should_have_many :aquatic_activities, :through => :aquatic_site_usages
  should_have_many :agencies, :through => :aquatic_site_usages
   
  should_require_attributes :description, :waterbody
  
  should "not validate location value objects when they are blank" do
    aquatic_site = AquaticSite.spawn
    location = mock('dummy_location') do
      expects(:blank?).at_least(2).returns(true)      
      expects(:valid?).never
    end
    aquatic_site.expects(:recorded_location).returns(location)
    aquatic_site.expects(:gmap_location).returns(location)
    assert aquatic_site.valid?
  end
  
  should "be valid if all location value objects are valid" do
    aquatic_site = AquaticSite.spawn
    location = mock('dummy_location') do
      expects(:blank?).at_least(2).returns(false)
      expects(:valid?).at_least(2).returns(true)
    end
    aquatic_site.expects(:recorded_location).returns(location)
    aquatic_site.expects(:gmap_location).returns(location)    
    assert aquatic_site.valid?
  end
  
  should "report errors on location value objects when they are not valid" do
    aquatic_site = AquaticSite.spawn
    errors = mock('dummy_errors') do
      expects(:on).with(:latitude).at_least(2).returns(['error1', 'error2'])
      expects(:on).with(:longitude).at_least(2).returns('error3')
      expects(:on).with(:coordinate_system_id).at_least(2).returns(nil)
    end
    location = mock('dummy_location') do
      expects(:blank?).at_least(2).returns(false)
      expects(:valid?).at_least(2).returns(false)
      expects(:errors).at_least_once.returns(errors)
    end
    aquatic_site.expects(:recorded_location).returns(location)
    aquatic_site.expects(:gmap_location).returns(location)    
    assert !aquatic_site.valid?
    assert_equal ['error1', 'error2'], aquatic_site.errors.on(:raw_latitude)
    assert_equal 'error3', aquatic_site.errors.on(:raw_longitude)
    assert_nil aquatic_site.errors.on(:coordinate_system_id)
    assert_equal ['error1', 'error2'], aquatic_site.errors.on(:gmap_latitude)
    assert_equal 'error3', aquatic_site.errors.on(:gmap_longitude)
    assert_nil aquatic_site.errors.on(:gmap_coordinate_system_id)
  end
  
  context "when site has been incorporated into the data warehouse" do
    setup { @aquatic_site = AquaticSite.generate!(:exported_at => DateTime.now) }
      
    should "throw error if delete is attempted" do 
      assert_raise(AquaticDataWarehouse::RecordIsIncorporated) { AquaticSite.destroy @aquatic_site.id }
    end
  end
  
  context "when activity events are attached to aquatic site" do
    setup do
      @aquatic_site = AquaticSite.generate!
      AquaticSiteUsage.generate!(:aquatic_site => @aquatic_site)
      assert_equal 1, @aquatic_site.aquatic_site_usages.length
    end
    
    should "throw error if delete is attempted" do
      assert_raise(AquaticSite::AquaticSiteInUse) { @aquatic_site.destroy }
    end
    
    should_eventually "cascade delete to activity events" do
      
    end
  end
end
