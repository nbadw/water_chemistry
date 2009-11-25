require File.dirname(__FILE__) + '/../../../../test_helper'

module Coordinate
  module Parsers
    class DecimalDegreesTest < ActiveSupport::TestCase
      should "parse valid decimal degrees coordinates" do
        coordinates = [
          "180",
          "-180",
          "90.0",
          "-90.0",
          "N 90",
          "E 180",
          "S 90",
          "W 180",
          "n 90",
          "e 180",
          "s 90",
          "w 180",
          "N90",
          "E180",
          "S90",
          "W180",
          "90N",
          "180S",
          "90E",
          "180W",
          "12.3456789"
        ]
        coordinates.each do |coordinate|
          assert DecimalDegrees.new(coordinate).parse, "#{coordinate} should be valid"
        end
      end

      should "raise a parser error for invalid decimal degrees coordinates" do
        coordinates = [
          "180 0 0",
          "90 0",
          "0-3.0",
          "0-12345",
          "W-47.7",
          "-47.7W",
          "abc"
        ]
        coordinates.each do |coordinate|
          assert_raise(Coordinate::Parsers::ParserError, "#{coordinate} should be invalid") do
            DecimalDegrees.new(coordinate).parse
          end
        end
      end
    end
  end
end
