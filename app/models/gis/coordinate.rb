# encoding: utf-8
require 'coordinate/degrees_minutes_seconds'
require 'coordinate/parsers/degrees_minutes_seconds'
require 'coordinate/degrees_minutes'
require 'coordinate/parsers/degrees_minutes'
require 'coordinate/decimal_degrees'
require 'coordinate/parsers/decimal_degrees'

module Coordinate
  class << self
    def parse(value)
      result = nil
      parsers.each do |parser|
        begin
          result = parser.new(value).parse
          break
        rescue
          result = nil
        end
      end
      result
    end

    private
    def parsers
      [
        Coordinate::Parsers::DegreesMinutesSeconds,
        Coordinate::Parsers::DegreesMinutes,
        Coordinate::Parsers::DecimalDegrees
      ]
    end
  end
end
