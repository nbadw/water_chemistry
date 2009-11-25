# encoding: utf-8
require 'coordinate'

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def self.parse(x, y)
    new(Coordinate.parse(x).to_decimal, Coordinate.parse(y).to_decimal)
  end
end
