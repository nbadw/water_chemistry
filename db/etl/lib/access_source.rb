require 'fileutils'
require 'win32ole'

module ETL #:nodoc:  
  module Control #:nodoc:
    # Source object which extracts data from a Microsoft Access database.
    class AccessSource < Source
      attr_accessor :mdb, :table
      
      # Initialize the source.
      #
      # Arguments:
      # * <tt>control</tt>: The ETL::Control::Control instance
      # * <tt>configuration</tt>: The configuration Hash
      # * <tt>definition</tt>: The source definition
      #
      # Required configuration options:
      # * <tt>:mdb</tt>: The target mdb file
      # * <tt>:table</tt>: The source table name
      # * <tt>:database</tt>: The database name
      # 
      # Other options:
      # * <tt>:join</tt>: Optional join part for the query (ignored unless 
      #   specified)
      # * <tt>:select</tt>: Optional select part for the query (defaults to 
      #   '*')
      # * <tt>:group</tt>: Optional group by part for the query (ignored 
      #   unless specified)
      # * <tt>:order</tt>: Optional order part for the query (ignored unless 
      #   specified)
      # * <tt>:new_records_only</tt>: Specify the column to use when comparing
      #   timestamps against the last successful ETL job execution for the
      #   current control file.
      # * <tt>:store_locally</tt>: Set to false to not store a copy of the 
      #   source data locally in a flat file (defaults to true)
      def initialize(control, configuration, definition)
        @control = control
        @configuration = configuration        
        @definition = definition
        
        @store_locally = configuration[:store_locally] || true
        @mdb   = configuration[:mdb]
        @table = configuration[:table]
        
        raise "File doesn't exist: #{@mdb}" unless File.exist?(@mdb)
      end
      
      # Get a String identifier for the source
      def to_s
        "#{File.basename(mdb)}/#{table}"
      end
      
      # Get the local directory to use, which is a combination of the 
      # local_base, the db hostname the db database name and the db table.
      def local_directory
        File.join(local_base, File.basename(configuration[:mdb]), configuration[:table])
      end
      
      # Get the join part of the query, defaults to nil
      def join
        configuration[:join]
      end
      
      # Get the select part of the query, defaults to '*'
      def select
        configuration[:select] || '*'
      end
      
      # Get the group by part of the query, defaults to nil
      def group
        configuration[:group]
      end
      
      # Get the order for the query, defaults to nil
      def order
        configuration[:order]
      end
      
      # Return the column which is used for in the where clause to identify
      # new rows
      def new_records_only
        configuration[:new_records_only]
      end
      
      # Get the number of rows in the source
      def count(use_cache=true)
        return @count if @count && use_cache
        if store_locally || read_locally
          @count = count_locally
        else
          @count = connection.select_value(query.gsub(/SELECT .* FROM/, 'SELECT count(1) FROM'))
        end
      end
      
      # Get the list of columns to read. This is defined in the source
      # definition as either an Array or Hash
      def columns
        case definition
        when Array
          definition.collect(&:to_sym)
        when Hash
          definition.keys.collect(&:to_sym)
        else
          raise "Definition must be either an Array or a Hash"
        end
      end
      
      # Returns each row from the source. If read_locally is specified then
      # this method will attempt to read from the last stored local file. 
      # If no locally stored file exists or if the trigger file for the last
      # locally stored file does not exist then this method will raise an
      # error.
      def each(&block)
        if read_locally # Read from the last stored source
          ETL::Engine.logger.debug "Reading from local cache"
          read_rows(last_local_file, &block)
        else # Read from the original source
          if store_locally
            file = local_file
            write_local(file)
            read_rows(file, &block)
          else
            connection.select_all(query).each do |row|
              row = ETL::Row.new(row.symbolize_keys)
              row.source = self
              yield row
            end
          end
        end
      end
      
      private
      # Read rows from the local cache
      def read_rows(file)
        raise "Local cache file not found" unless File.exists?(file)
        raise "Local cache trigger file not found" unless File.exists?(local_file_trigger(file))
        
        t = Benchmark.realtime do
          FasterCSV.open(file, :headers => true).each do |row|
            result_row = ETL::Row.new
            result_row.source = self
            row.each do |header, field|
              result_row[header.to_sym] = field
            end
            yield result_row
          end
        end
        ETL::Engine.average_rows_per_second = ETL::Engine.rows_read / t
      end
      
      def count_locally
        counter = 0
        File.open(last_local_file, 'r').each { |line| counter += 1 }
        counter
      end
      
      # Write rows to the local cache
      def write_local(file)
        lines = 0
        t = Benchmark.realtime do
          FasterCSV.open(file, 'w') do |f|
            f << columns
            connection.select_all(query).each do |row|
              f << columns.collect { |column| row[column.to_s] }
              lines += 1
            end
          end
          File.open(local_file_trigger(file), 'w') {|f| }
        end
        ETL::Engine.logger.info "Stored locally in #{t}s (avg: #{lines/t} lines/sec)"
      end
      
      # Get the query to use
      def query
        return @query if @query
        
        q = "SELECT #{select} FROM #{table}"          
        q = q.gsub(/\n/,' ')
        ETL::Engine.logger.info "Query: #{q}"
        @query = q
      end
      
      # Get the database connection to use
      def connection
        @connection ||= AccessConnection.new(mdb)   
      end
    end
  end
end

class AccessConnection
  attr_accessor :connection_string
  
  def initialize(mdb)
    @connection_string = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=#{File.expand_path(mdb).gsub('/', '\\')}"
  end  
    
  def select_value(sql)
    execute_query(sql) do |recordset|
      recordset.GetRows.transpose[0]
    end    
  end
  
  def select_all(sql)
    execute_query(sql) do |recordset|
      fields = []
      recordset.Fields.each { |field| fields << field.Name }

      rows = recordset.GetRows.transpose.collect do |row_data|
        record = {}
        fields.each_index{ |i| record[fields[i]] = row_data[i] }
        record      
      end

      rows
    end
  end
  
  def execute_query(sql, &block)
    begin
      connection = WIN32OLE.new('ADODB.Connection')
      connection.Open(connection_string)
      recordset = WIN32OLE.new('ADODB.Recordset')
      recordset.Open(sql, connection)          
      result = yield recordset      
    ensure
      recordset.Close if recordset
      connection.Close if connection
    end
    result
  end
end