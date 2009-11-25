# encoding: utf-8
require 'coordinate'

module Coordinate
  class DegreesMinutesSeconds
    attr_accessor :degrees, :minutes, :seconds

    def initialize(degrees, minutes, seconds)
      @degrees, @minutes, @seconds = degrees, minutes, seconds
    end

    def to_decimal
      total_seconds = (minutes * 60) + seconds
      fraction_part = total_seconds / 3600
      result = degrees.to_f.abs + fraction_part
      result = -1.0 * result if degrees < 0
      result
    end

    def self.parse(value)
      Coordinate::Parsers::DegreesMinutesSeconds.new(value).parse
    end
  end
end
