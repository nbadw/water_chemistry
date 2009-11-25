require File.dirname(__FILE__) + '/../../../test_helper'

module Coordinate
  class DegreesMinutesTest < ActiveSupport::TestCase
    should "have degrees attribute" do
      dm = DegreesMinutes.new(10, 1.2345)
      assert_equal 10, dm.degrees
    end

    should "have minutes attribute" do
      dm = DegreesMinutes.new(10, 1.2345)
      assert_equal 1.2345, dm.minutes
    end

    should "convert to decimal representation" do
      values = {
        "0 0"        => 0.0,
        "180 0"      => 180.0,
        "-180 0"     => -180.0,
        "45 7.407"   => 45.12345,
        "-45 7.407"  => -45.12345
      }
      values.each do |value, expected|
        dm = DegreesMinutes.parse(value)
        assert_equal expected, dm.to_decimal
      end
    end
  end
end
