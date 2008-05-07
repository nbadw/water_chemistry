require File.dirname(__FILE__) + '/../test_helper'

class ActivityTest < ActiveSupport::TestCase
  should_belong_to :agency
  should_have_many :tasks
end
