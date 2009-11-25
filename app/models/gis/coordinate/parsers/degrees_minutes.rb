# encoding: utf-8
require 'coordinate'
require 'coordinate/parsers/parser_error'

module Coordinate
  module Parsers
    class DegreesMinutes < StringScanner
      DIRECTION    = /([NSEW])/i
      SIGN         = /([+-])/
      IGNORE       = /[\s]/
      DEGREE_UNITS = /[:d°]/i
      MINUTE_UNITS = /[:m']/i
      INTEGER      = /(-?0|-?[1-9]\d*)/
      FLOAT        = /(-?
                      (?:0|[1-9]\d*)
                      (?:
                        \.\d+(?i:e[+-]?\d+) |
                        \.\d+ |
                        (?i:e[+-]?\d+)
                      )
                      )/x

      def initialize(value)
        super(value.to_s)
        @sign = nil
        @degrees = nil
        @minutes = nil
      end

      def parse
        reset
        until eos?
          case
          when match?(DIRECTION)
            parse_direction
          when match?(SIGN)
            parse_sign
          when match?(INTEGER)
            parse_degrees_minutes
          when skip(IGNORE)
            ;
          else
            raise ParserError, "#{string} is not in degrees minutes format"
          end
        end
        
        begin
          Coordinate::DegreesMinutes.new(Integer("#{@sign}#{@degrees}"), Float(@minutes))
        rescue Exception => e
          raise ParserError, e
        end
      end

      private
      def parse_direction
        raise ParserError, "sign has already been set in #{string}" if @sign
        case scan(DIRECTION).upcase
        when "N","E" then @sign = ""
        when "S","W" then @sign = "-"
        end
      end

      def parse_sign
        raise ParserError, "sign has already been set in #{string}" if @sign
        case scan(SIGN)
        when "+" then @sign = ""
        when "-" then @sign = "-"
        end
      end

      def parse_degrees_minutes
        raise ParserError, "degrees minutes have already been read in #{string}" if (@degrees && @minutes)
        parse_degrees
        parse_minutes
      end

      def parse_degrees
        @degrees = scan(INTEGER)
        skip(DEGREE_UNITS)
        skip(IGNORE)
      end

      def parse_minutes
        @minutes = case
        when scan(FLOAT)   then self[1]
        when scan(INTEGER) then self[1]
        end
        skip(MINUTE_UNITS)
      end
    end
  end
end


