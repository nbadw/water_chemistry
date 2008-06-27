require File.dirname(__FILE__) + '/../test_helper'

class AgencyTest < ActiveSupport::TestCase
  should_require_attributes :name
  should_have_many :users, :aquatic_site_agency_usages  
end
