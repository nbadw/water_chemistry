require File.dirname(__FILE__) + '/../test_helper'

class TblSampleTest < ActiveSupport::TestCase
  should_belong_to :aquatic_activity
  should_have_many :water_measurements
end
