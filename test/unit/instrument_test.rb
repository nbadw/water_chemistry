require File.dirname(__FILE__) + '/../test_helper'

class InstrumentTest < ActiveSupport::TestCase
  should_have_and_belong_to_many :measurements
end
