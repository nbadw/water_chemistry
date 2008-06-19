require File.dirname(__FILE__) + '/../test_helper'

class TblAquaticSiteTest < ActiveSupport::TestCase
  should_belong_to :waterbody 
  should_have_many :aquatic_site_agency_usages
  should_have_many :aquatic_activity_codes, :through => :aquatic_site_agency_usages
  should_have_many :agencies, :through => :aquatic_site_agency_usages
   
  should_require_attributes :description, :waterbody
  
  should "be valid if both xcoordinate and ycoordinate are blank" do
    aquatic_site = TblAquaticSite.spawn
    assert_valid aquatic_site
    aquatic_site.xcoordinate = nil
    aquatic_site.ycoordinate = nil
    assert_valid aquatic_site
  end
  
  should "be invalid if xcoordinate is present and ycoordinate is not" do 
    aquatic_site = TblAquaticSite.spawn
    assert_valid aquatic_site
    aquatic_site.xcoordinate = '45.347'
    aquatic_site.ycoordinate = nil
    assert !aquatic_site.valid?
    assert_equal 1, aquatic_site.errors.count
  end
  
  should "be invalid if ycoordinate is present and xcoordinate is not" do 
    aquatic_site = TblAquaticSite.spawn
    assert_valid aquatic_site
    aquatic_site.xcoordinate = nil
    aquatic_site.ycoordinate = '73.915'
    assert !aquatic_site.valid?
    assert_equal 1, aquatic_site.errors.count
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
    end
    
    should_eventually "throw error if delete is attempted" do
      assert_raise(TblAquaticSite::AquaticSiteInUse) { @aquatic_site.destroy }
    end
    
    should_eventually "cascade delete to activity events" do
      
    end
  end
end
