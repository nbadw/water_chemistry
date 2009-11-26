require File.dirname(__FILE__) + '/../../../../test_helper'

module Coordinate
  module Parsers
    class DegreesMinutesSecondsTest < ActiveSupport::TestCase
      should "parse valid degrees minutes seconds coordinates" do
        coordinates = [
          "-90 0 0",
          "-180 0 0",
          "90 0 0",
          "180 0 0",
          "-90 0 0.0",
          "-180 0 0.0",
          "90 0 0.0",
          "180 0 0.0",
          "N 90 0 0",
          "E 180 0 0",
          "S 90 0 0",
          "W 180 0 0",
          "N90 0 0",
          "E180 0 0",
          "S90 0 0",
          "W180 0 0",
          "90 0 0 N",
          "180 0 0 E",
          "90 0 0 S",
          "180 0 0 W",
          "90 0 0N",
          "180 0 0E",
          "90 0 0S",
          "180 0 0W",
          "1d2m3.0s",
          "1:2:3.0",
          "1°2'3\"",
          "-1d 2m 3.0s",
          "-1D 2M 3.0S",
          "n 1 2 3",
          "e 1 2 3",
          "s 1 2 3",
          "w 1 2 3",
          "W65˚ 4' 45.9"
        ]
        coordinates.each do |coordinate|
          assert DegreesMinutesSeconds.new(coordinate).parse, "#{coordinate} should be valid"
        end
      end

      should "raise an error" do
        assert DegreesMinutesSeconds.new("W65˚ 4' 45.9").parse
      end

      should "raise a parser error for invalid degrees minutes seconds coordinates" do
        coordinates = [
          "0-90 0 0",
          "0",
          "0.0",
          "-90 0 0W",
          "180.0 0 0",
          "180 2.3 0",
          "180 0 0 90 0 0",
          "abc"
        ]
        coordinates.each do |coordinate|
          assert_raise(Coordinate::Parsers::ParserError, "#{coordinate} should be invalid") do
            DegreesMinutesSeconds.new(coordinate).parse
          end
        end
      end
    end
  end
end
