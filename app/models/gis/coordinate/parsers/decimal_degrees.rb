# encoding: utf-8
require 'coordinate'
require 'coordinate/parsers/parser_error'

module Coordinate
  module Parsers
    class DecimalDegrees < StringScanner
      DIRECTION    = /([NSEW])/i
      SIGN         = /([+-])/
      IGNORE       = /[\s]/
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
            parse_degrees
          when match?(FLOAT)
            parse_degrees
          when skip(IGNORE)
            ;
          else
            raise ParserError, "#{string} is not in degrees minutes seconds format"
          end
        end
        
        begin
          Coordinate::DecimalDegrees.new(Float("#{@sign}#{@degrees}"))
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

      def parse_degrees
        raise ParserError, "degrees have already been read in #{string}" if @degrees
        @degrees =  case
        when scan(FLOAT)   then self[1]
        when scan(INTEGER) then self[1]
        end
      end
    end
  end
end


