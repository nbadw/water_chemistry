module ETL 
  module Processor 
    class NullifyProcessor < ETL::Processor::RowProcessor
      # An array of fields to check
      attr_reader :null
      
      # Initialize the processor
      #
      # Options:
      # * <tt>:null</tt>: The value to insert if field is null or blank
      def initialize(control, configuration)
        super
        @null = configuration[:null] || "\\N"
      end
      
      # Process the row.
      def process(row)
        row.each do |attr, value|
          row[attr] = null if value.to_s.blank?
          row[attr] = 1 if value == 'true'
          row[attr] = 0 if value == 'false'
        end
        row
      end
    end
  end
end