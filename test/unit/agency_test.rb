require File.dirname(__FILE__) + '/../test_helper'

class AgencyTest < ActiveSupport::TestCase
  should_require_attributes :name
  should_have_many :users, :aquatic_site_usages 

  should_define_attributes :code, :name, :type, :data_rules
  should_define_timestamps
end
