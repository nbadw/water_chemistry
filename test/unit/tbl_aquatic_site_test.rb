require File.dirname(__FILE__) + '/../test_helper'

class TblAquaticSiteTest < ActiveSupport::TestCase
  should_belong_to :waterbody 
  should_have_many :aquatic_site_agency_usages
  should_have_many :aquatic_activity_codes, :through => :aquatic_site_agency_usages
  should_have_many :agencies, :through => :aquatic_site_agency_usages
   
  should_require_attributes :description, :waterbody
     
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
    
    should "throw error if delete is attempted" do
      assert_raise(TblAquaticSite::AquaticSiteInUse) { @aquatic_site.destroy }
    end
    
    should_eventually "cascade delete to activity events" do
      
    end
  end
end
