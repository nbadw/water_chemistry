require File.dirname(__FILE__) + '/../test_helper'

class AquaticSiteUsageTest < ActiveSupport::TestCase
  should_belong_to :aquatic_site, :aquatic_activity, :agency    
  should_require_attributes :aquatic_site, :agency, :aquatic_activity
  
  context "with an existing record" do
    setup { AquaticSiteUsage.generate! }
    should_require_unique_attributes :aquatic_activity_id, :scoped_to => :aquatic_site_id
  end
end
