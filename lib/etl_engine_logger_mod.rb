module ETL
  class Engine
    def self.logger #:nodoc:
        unless @logger
          if timestamped_log
            @logger = Logger.new("etl_#{timestamp}.log")
          else
            @logger = Logger.new(File.open('log/etl.log', log_write_mode))
          end
          @logger.level = Logger::WARN
          @logger.formatter = Logger::Formatter.new
        end
        @logger
      end
  end
end