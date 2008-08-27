require 'fileutils'
require 'win32ole'

module ActiveRecord
  class Base
    def self.ms_access_connection(config) # :nodoc:
      parse_ms_access_config!(config)
      ConnectionAdapters::MsAccessAdapter.new(config[:database], logger)
    end
    
    private
    def self.parse_ms_access_config!(config)
      config[:database] ||= config[:mdbfile]
      # Require database.
      unless config[:database]
        raise ArgumentError, "No database file specified. Missing argument: database"
      end

      # Allow database path relative to RAILS_ROOT, but only if
      # the database path is not the special path that tells
      # Sqlite to build a database only in memory.
      if Object.const_defined?(:RAILS_ROOT)
        config[:database] = File.expand_path(config[:database], RAILS_ROOT)
      end
    end
  end
  
  module ConnectionAdapters #:nodoc:
    class MsAccessAdapter < AbstractAdapter # :nodoc:
      attr_accessor :connection_string
      
      def initialize(mdb, logger)
        @connection_string = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=#{File.expand_path(mdb).gsub('/', '\\')}"
        adodb_connection = WIN32OLE.new('ADODB.Connection')
        adodb_connection.Open(@connection_string)
        super(adodb_connection, logger)
      end  
  
      def tables(name = nil)            
        catalog = WIN32OLE.new("ADOX.Catalog")
        catalog.ActiveConnection = @connection      
        tables = []
        catalog.Tables.each do |table|        
          tables << table.Name if table.Type == 'TABLE' || table.Type == 'LINK'
        end 
        tables
      end
      
      def columns(table_name, name = nil)
        return [] if table_name.blank?
        table_name = table_name.to_s if table_name.is_a?(Symbol)
            
        catalog = WIN32OLE.new("ADOX.Catalog")
        catalog.ActiveConnection = @connection
      
        table = catalog.Tables(table_name)
        columns = []
        table.Columns.each do |column| 
          columns << MsAccessColumn.new(column)          
        end
        columns  
      end    
    
      def reconnect!
        disconnect!
        adodb_connection = WIN32OLE.new('ADODB.Connection')
        adodb_connection.Open(@connection_string)
        @connection = adodb_connection
      rescue Exception => e
        @logger.warn "#{adapter_name} reconnection failed: #{e.message}" if @logger
        false
      end
      
      def disconnect!
        @connection.Close rescue nil
      end
    end

    class MsAccessColumn < Column
      def initialize(ado_column)        
        super(ado_column.Name, default_value(ado_column), adox_sql_type(ado_column), nullable?(ado_column))        
        @default = nil if @sql_type == :datetime
        @limit = defined_size(ado_column)
      end
      
      def adox_sql_type(column) 
        case column.Type
        when 2   then :integer
        when 3   then :integer
        when 4   then :float
        when 5   then :decimal
        when 7   then :datetime
        when 11  then :boolean
        when 202 then :string
        else
          raise "Unknown ADOX data type: #{column.Type} - http://msdn.microsoft.com/en-us/library/ms675318(VS.85).aspx"
        end
      end
      
      def defined_size(column)
        if @sql_type == :string
          column.DefinedSize if column.DefinedSize > 0
        elsif @sql_type == :float
          column.Precision if column.Precision > 0
        end
      end
         
      def nullable?(column)
        property = get_property('Nullable', column)
        property.Value if property
      end
         
      def default_value(column)          
        property = get_property('Default', column)
        property.Value if property
      end
      
      def get_property(name, column)
        column.Properties.each do |property|
          return property if property.Name == name
        end
      end
    end
  end
end

