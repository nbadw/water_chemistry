# encoding: utf-8
require 'coordinate'

module Coordinate
  class DecimalDegrees
    attr_accessor :degrees

    def initialize(degrees)
      @degrees = degrees
    end

    def to_decimal
      degrees.to_f
    end

    def self.parse(value)
      Coordinate::Parsers::DecimalDegrees.new(value).parse
    end
  end
end
