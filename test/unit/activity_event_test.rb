require File.dirname(__FILE__) + '/../test_helper'

class ActivityEventTest < ActiveSupport::TestCase
  should_belong_to :aquatic_site
  should_belong_to :activity
end
