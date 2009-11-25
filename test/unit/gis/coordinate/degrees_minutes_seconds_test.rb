require File.dirname(__FILE__) + '/../../../test_helper'

module Coordinate
  class DegreesMinutesSecondsTest < ActiveSupport::TestCase
    should "have degrees attribute" do
      dms = DegreesMinutesSeconds.new(100, 37, 1.2345)
      assert_equal 100, dms.degrees
    end

    should "have minutes attribute" do
      dms = DegreesMinutesSeconds.new(100, 37, 1.2345)
      assert_equal 37, dms.minutes
    end

    should "have seconds attribute" do
      dms = DegreesMinutesSeconds.new(100, 37, 1.2345)
      assert_equal 1.2345, dms.seconds
    end

    should "convert to decimal representation" do
      values = {
        "0 0 0"        => 0.0,
        "180 0 0"      => 180.0,
        "-180 0 0"     => -180.0,
        "45 7 24.42"   => 45.12345,
        "W 45 7 24.42" => -45.12345,
        "45 7 24.42 W" => -45.12345
      }
      values.each do |value, expected|
        dms = DegreesMinutesSeconds.parse(value)
        assert_equal expected, dms.to_decimal
      end
    end
  end
end
