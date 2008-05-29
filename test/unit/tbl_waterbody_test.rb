require File.dirname(__FILE__) + '/../test_helper'

class TblWaterbodyTest < ActiveSupport::TestCase
  should_have_many :aquatic_sites
  #should_belong_to :watershed
end
