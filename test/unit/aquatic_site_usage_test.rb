require File.dirname(__FILE__) + '/../test_helper'

class AquaticSiteUsageTest < ActiveSupport::TestCase
  should_belong_to :aquatic_site
  should_belong_to :activity
  should_belong_to :agency
  
  context "given as existing record" do
    setup { @aquatic_site_usage = AquaticSiteUsage.generate! }
        
    should_require_attributes :activity
  end    
end
