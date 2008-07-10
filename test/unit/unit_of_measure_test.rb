require File.dirname(__FILE__) + '/../test_helper'

class UnitOfMeasureTest < ActiveSupport::TestCase
  should_have_and_belong_to_many :measurements
end
