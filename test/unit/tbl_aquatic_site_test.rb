require File.dirname(__FILE__) + '/../test_helper'

class TblAquaticSiteTest < ActiveSupport::TestCase
  should_belong_to :waterbody 
  should_have_many :aquatic_site_agency_usages
  should_have_many :aquatic_activity_codes, :through => :aquatic_site_agency_usages
  should_have_many :agencies, :through => :aquatic_site_agency_usages
   
  should_require_attributes :description, :waterbody
  
  should "be valid if all coordinate parameters are nil" do
    aquatic_site = TblAquaticSite.spawn
    assert_nil aquatic_site.x_coordinate
    assert_nil aquatic_site.y_coordinate
    assert_nil aquatic_site.coordinate_system
    assert_nil aquatic_site.coordinate_source
    assert_valid aquatic_site
  end
  
  should "be valid if all coordinate parameters are blank" do
    aquatic_site = TblAquaticSite.spawn
    aquatic_site.attributes.update(:x_coordinate => '', :y_coordinate => '', :coordinate_system => '', :coordinate_source => '')
    assert_valid aquatic_site
  end
  
  should "be invalid if only x_coordinate parameter is present" do 
    aquatic_site = TblAquaticSite.spawn
    aquatic_site.xcoordinate = '45.347'
    assert !aquatic_site.valid?
  end
  
  should "be invalid if only y_coordinate parameter is present" do 
    aquatic_site = TblAquaticSite.spawn
    aquatic_site.ycoordinate = '78.9464'
    assert !aquatic_site.valid?
  end
  
  should "be invalid if only coordinate_system parameter is present" do 
    aquatic_site = TblAquaticSite.spawn
    aquatic_site.coordinate_system = 'WGS84'
    assert !aquatic_site.valid?
  end
  
  should "be invalid if only coordinate_source parameter is present" do 
    aquatic_site = TblAquaticSite.spawn
    aquatic_site.coordinate_source = 'GPS'
    assert !aquatic_site.valid?
  end
     
  context "when site has been incorporated into the data warehouse" do
    setup { @aquatic_site = TblAquaticSite.generate!(:incorporated => true) }
      
    should "throw error if delete is attempted" do 
      assert_raise(TblAquaticSite::RecordIsIncorporated) { TblAquaticSite.destroy @aquatic_site.id }
    end
  end
  
  context "when activity events are attached to aquatic site" do
    setup do
      @aquatic_site = TblAquaticSite.generate!
      @aquatic_site.aquatic_site_agency_usages << TblAquaticSiteAgencyUse.generate!
      @aquatic_site.save
    end
    
    should "throw error if delete is attempted" do
      assert_raise(TblAquaticSite::AquaticSiteInUse) { @aquatic_site.destroy }
    end
    
    should_eventually "cascade delete to activity events" do
      
    end
  end
end
