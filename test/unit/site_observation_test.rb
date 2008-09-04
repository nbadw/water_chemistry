require File.dirname(__FILE__) + '/../test_helper'

class SiteObservationTest < ActiveSupport::TestCase
  should_eventually '_belong_to :aquatic_site, :aquatic_activity_event, :observation'
  should_eventually '_require_attributes :aquatic_site, :aquatic_activity_event, :observation'
end
