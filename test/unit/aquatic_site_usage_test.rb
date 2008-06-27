require File.dirname(__FILE__) + '/../test_helper'

class AquaticSiteUsageTest < ActiveSupport::TestCase
  should_belong_to :aquatic_site, :aquatic_activity, :agency    
  should_require_attributes :aquatic_site, :agency, :aquatic_activity
end
