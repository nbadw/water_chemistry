require File.dirname(__FILE__) + '/../../../../test_helper'

module Coordinate
  module Parsers
    class DegreesMinutesTest < ActiveSupport::TestCase
      should "parse valid degrees minutes coordinates" do
        coordinates = [
          "180 0",
          "180° 0'",
          "180d0",
          "-90 0",
          "90 0.0",
          "45° 7.407'",
          "45:7.407",
          "45d7.407m",
          "45d 7.407"
        ]
        coordinates.each do |coordinate|
          assert DegreesMinutes.new(coordinate).parse, "#{coordinate} should be valid"
        end
      end

      should "raise a parser error for invalid degrees minutes coordinates" do
        coordinates = [
          "0-90 0",
          "0",
          "0.0",
          "-90 0W",
          "180.0 0",
          "180x2.3",
          "180 0 90 0",
          "abc"
        ]
        coordinates.each do |coordinate|
          assert_raise(Coordinate::Parsers::ParserError, "#{coordinate} should be invalid") do
            DegreesMinutes.new(coordinate).parse
          end
        end
      end
    end
  end
end
