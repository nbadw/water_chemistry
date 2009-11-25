require File.dirname(__FILE__) + '/../../../test_helper'

module Coordinate
  class DecimalDegreesTest < ActiveSupport::TestCase
    should "have degrees attribute" do
      dd = DecimalDegrees.new(1.2345)
      assert_equal 1.2345, dd.degrees
    end

    should "convert to decimal representation" do
      values = {
        "0"        => 0.0,
        "180"      => 180.0,
        "-180"     => -180.0,
        "45.12345" => 45.12345
      }
      values.each do |value, expected|
        dd = DecimalDegrees.parse(value)
        assert_equal expected, dd.to_decimal
      end
    end
  end
end
