require File.dirname(__FILE__) + '/../test_helper'

class AquaticSiteUsageTest < ActiveSupport::TestCase
  should_belong_to :aquatic_site
  should_belong_to :activity
  should_belong_to :agency
  
  context "given as existing record" do
    setup { @aquatic_site_usage = AquaticSiteUsage.generate! }
        
    should_require_attributes :activity
  end
  
  context "waterbody method" do       
    setup do
      @aquatic_site_usage = AquaticSiteUsage.generate
      assert_nil @aquatic_site_usage.aquatic_site      
    end
      
    should "return nil when aquatic site is nil" do
      assert_nil @aquatic_site_usage.waterbody
    end
      
    should "return nil when aquatic_site.waterbody is nil" do      
      @aquatic_site_usage.aquatic_site = AquaticSite.generate
      assert_nil @aquatic_site_usage.aquatic_site.waterbody
      assert_nil @aquatic_site_usage.waterbody
    end
      
    should "return waterbody" do    
      @aquatic_site_usage.aquatic_site = AquaticSite.generate
      @aquatic_site_usage.aquatic_site.waterbody = Waterbody.generate
      assert_not_nil @aquatic_site_usage.waterbody
    end
  end
  
end
