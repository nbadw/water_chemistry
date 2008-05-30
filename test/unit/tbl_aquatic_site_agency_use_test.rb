require File.dirname(__FILE__) + '/../test_helper'

class TblAquaticSiteAgencyUseTest < ActiveSupport::TestCase
  should_belong_to :aquatic_site
  should_belong_to :aquatic_activity_code
  should_belong_to :agency  
end
