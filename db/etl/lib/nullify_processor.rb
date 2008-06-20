module ETL 
  module Processor 
    class NullifyProcessor < ETL::Processor::RowProcessor
      # An array of fields to check
      attr_reader :fields, :null
      
      # Initialize the processor
      #
      # Options:
      # * <tt>:fields</tt>: An array of fields to check, for example:
      #   [:first_name,:last_name]
      # * <tt>:null</tt>: The value to insert if field is null or blank
      def initialize(control, configuration)
        super
        @fields = configuration[:fields] || []
        @null = configuration[:null] || 'NULL'
      end
      
      # Process the row.
      def process(row)
        fields.each { |field| row[field] = null if row[field].to_s.blank? }
        row
      end
    end
  end
end