require File.dirname(__FILE__) + '/../test_helper'

class TblAquaticActivityTest < ActiveSupport::TestCase
  should_belong_to :aquatic_activity_code
  should_belong_to :aquatic_site
  should_belong_to :agency
  should_belong_to :agency2
  should_belong_to :aquatic_activity_method_code
end
