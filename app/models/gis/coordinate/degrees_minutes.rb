# encoding: utf-8
require 'coordinate'

module Coordinate
  class DegreesMinutes
    attr_accessor :degrees, :minutes

    def initialize(degrees, minutes)
      @degrees, @minutes = degrees, minutes
    end

    def to_decimal
      total_seconds = minutes * 60
      fraction_part = total_seconds / 3600
      result = degrees.to_f.abs + fraction_part
      result = -1.0 * result if degrees < 0
      result
    end

    def self.parse(value)
      Coordinate::Parsers::DegreesMinutes.new(value).parse
    end
  end
end
