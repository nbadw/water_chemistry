require File.dirname(__FILE__) + '/../test_helper'

class PermissionTest < ActiveSupport::TestCase
  should_belong_to :role
  should_belong_to :user
end
