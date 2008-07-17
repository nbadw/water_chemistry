module ActiveRecord
  class Composite < Base
    self.abstract_class = true

    attr_accessor :id
    def id
      @id
    end

    attr_accessor :found
    attr_accessor :sort_order

    def self.count(*args)
      0
    end

    class << self
      def find(*args)
        []
      end

      def columns()
        @columns ||= []
      end

      def column(name, sql_type = nil, default = nil, null = true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
        reset_column_information
      end

      def reset_column_information
        @column_names = @columns_hash = @content_columns = @dynamic_methods_hash = @read_methods = nil
      end

      def find(*args)
        options = args.extract_options!
        validate_find_options(options)
        set_readonly_option!(options)

        case args.first
        when :first then find_initial(options)
        when :all   then find_every(options)
        else find_from_ids(args, options)
        end    
      end        
    end
  end
end