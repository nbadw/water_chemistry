# encoding: utf-8
require 'coordinate'
require 'coordinate/parsers/parser_error'

module Coordinate
  module Parsers
    class DegreesMinutesSeconds < StringScanner
      DIRECTION    = /([NSEW])/i
      SIGN         = /([+-])/
      IGNORE       = /[\s]/
      DEGREE_UNITS = /[:d°]/i
      MINUTE_UNITS = /[:m']/i
      SECOND_UNITS = /[:s\"]/i
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
        @seconds = nil
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
            parse_degrees_minutes_seconds
          when skip(IGNORE)
            ;
          else
            raise ParserError, "#{string} is not in degrees minutes seconds format"
          end
        end
        
        begin
          Coordinate::DegreesMinutesSeconds.new(Integer("#{@sign}#{@degrees}"), Integer(@minutes), Float(@seconds))
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

      def parse_degrees_minutes_seconds
        raise ParserError, "degrees minutes seconds have already been read in #{string}" if (@degrees && @minutes && @seconds)
        parse_degrees
        parse_minutes
        parse_seconds
      end

      def parse_degrees
        @degrees = scan(INTEGER)
        skip(DEGREE_UNITS)
        skip(IGNORE)
      end

      def parse_minutes
        @minutes = scan(INTEGER)
        skip(MINUTE_UNITS)
        skip(IGNORE)
      end

      def parse_seconds
        @seconds = case
        when scan(FLOAT)   then self[1]
        when scan(INTEGER) then self[1]
        end
        skip(SECOND_UNITS)
      end
    end
  end
end


