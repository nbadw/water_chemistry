require 'active_record/connection_adapters/abstract_adapter'

require 'bigdecimal'
require 'bigdecimal/util'

# sqlserver_adapter.rb -- ActiveRecord adapter for Microsoft SQL Server
#
# Author: Joey Gibson <joey@joeygibson.com>
# Date:   10/14/2004
#
# Modifications: DeLynn Berry <delynnb@megastarfinancial.com>
# Date: 3/22/2005
#
# Modifications (ODBC): Mark Imbriaco <mark.imbriaco@pobox.com>
# Date: 6/26/2005

# Modifications (Migrations): Tom Ward <tom@popdog.net>
# Date: 27/10/2005
#
# Modifications (Numerous fixes as maintainer): Ryan Tomayko <rtomayko@gmail.com>
# Date: Up to July 2006

# Current maintainer: Tom Ward <tom@popdog.net>

module ActiveRecord
  class Base
    def self.sqlserver_connection(config) #:nodoc:
      require_library_or_gem 'dbi' unless self.class.const_defined?(:DBI)
      
      config = config.symbolize_keys

      mode        = config[:mode] ? config[:mode].to_s.upcase : 'ADO'
      username    = config[:username] ? config[:username].to_s : 'sa'
      password    = config[:password] ? config[:password].to_s : ''
      auth        = config[:windows_auth] ? 'Integrated Security=SSPI' : "User ID=#{username};Password=#{password}" 
      autocommit  = config.key?(:autocommit) ? config[:autocommit] : true
      if mode == "ODBC"
        raise ArgumentError, "Missing DSN. Argument ':dsn' must be set in order for this adapter to work." unless config.has_key?(:dsn)
        dsn       = config[:dsn]
        driver_url = "DBI:ODBC:#{dsn}"
      else
        raise ArgumentError, "Missing Database. Argument ':database' must be set in order for this adapter to work." unless config.has_key?(:database)
        database  = config[:database]
        host      = config[:host] ? config[:host].to_s : 'localhost'
        provider  = config[:provider] ? config[:provider].to_s : 'SQLOLEDB'
        driver_url = "DBI:ADO:Provider=#{provider};Data Source=#{host};Initial Catalog=#{database};#{auth};" 
      end
      conn      = DBI.connect(driver_url, username, password)
      conn["AutoCommit"] = autocommit
      ConnectionAdapters::SQLServerAdapter.new(conn, logger, [driver_url, username, password])
    end
  end # class Base

  module ConnectionAdapters
    class SQLServerColumn < Column# :nodoc:
      attr_reader :identity, :is_special

      def initialize(name, default, sql_type = nil, identity = false, null = true) # TODO: check ok to remove scale_value = 0
        super(name, default, sql_type, null)
        @identity = identity
        @is_special = sql_type =~ /text|ntext|image/i
        # TODO: check ok to remove @scale = scale_value
        # SQL Server only supports limits on *char and float types
        @limit = nil unless @type == :float or @type == :string
      end

      def simplified_type(field_type)
        case field_type
        when /real/i              then :float
        when /money/i             then :decimal
        when /image/i             then :binary
        when /bit/i               then :boolean
        when /uniqueidentifier/i  then :string
        else super
        end
      end

      def type_cast(value)
        return nil if value.nil?
        case type
        when :datetime  then cast_to_datetime(value)
        when :timestamp then cast_to_time(value)
        when :time      then cast_to_time(value)
        when :date      then cast_to_datetime(value)
        when :boolean   then value == true or (value =~ /^t(rue)?$/i) == 0 or value.to_s == '1'
        else super
        end
      end
      
      def cast_to_time(value)
        return value if value.is_a?(Time)
        time_array = ParseDate.parsedate(value)
        Time.time_with_datetime_fallback(Base.default_timezone, *time_array) rescue nil
        #Time.send(Base.default_timezone, *time_array) rescue nil
      end

      def cast_to_datetime(value)
        return value.to_time if value.is_a?(DBI::Timestamp)
        
        if value.is_a?(Time)
          if value.year != 0 and value.month != 0 and value.day != 0
            return value
          else
            return Time.mktime(2000, 1, 1, value.hour, value.min, value.sec) rescue nil
          end
        end
   
        if value.is_a?(DateTime)
          return Time.time_with_datetime_fallback(Base.default_timezone, value.year, value.mon, value.day, value.hour, value.min, value.sec)
        end
        
        return cast_to_time(value) if value.is_a?(Date) or value.is_a?(String) rescue nil
        value
      end
      
      # TODO: Find less hack way to convert DateTime objects into Times
      
      def self.string_to_time(value)
        if value.is_a?(DateTime)
          return Time.time_with_datetime_fallback(Base.default_timezone, value.year, value.mon, value.day, value.hour, value.min, value.sec)
        else
          super
        end
      end

      # These methods will only allow the adapter to insert binary data with a length of 7K or less
      # because of a SQL Server statement length policy.
      def self.string_to_binary(value) 
        Base64.encode64(value) 
      end 
 	       
      def self.binary_to_string(value) 
        Base64.decode64(value) 
      end 
    end

    # In ADO mode, this adapter will ONLY work on Windows systems, 
    # since it relies on Win32OLE, which, to my knowledge, is only 
    # available on Windows.
    #
    # This mode also relies on the ADO support in the DBI module. If you are using the
    # one-click installer of Ruby, then you already have DBI installed, but
    # the ADO module is *NOT* installed. You will need to get the latest
    # source distribution of Ruby-DBI from http://ruby-dbi.sourceforge.net/
    # unzip it, and copy the file 
    # <tt>src/lib/dbd_ado/ADO.rb</tt> 
    # to
    # <tt>X:/Ruby/lib/ruby/site_ruby/1.8/DBD/ADO/ADO.rb</tt> 
    # (you will more than likely need to create the ADO directory).
    # Once you've installed that file, you are ready to go.
    #
    # In ODBC mode, the adapter requires the ODBC support in the DBI module which requires
    # the Ruby ODBC module.  Ruby ODBC 0.996 was used in development and testing,
    # and it is available at http://www.ch-werner.de/rubyodbc/
    #
    # Options:
    #
    # * <tt>:mode</tt>      -- ADO or ODBC. Defaults to ADO.
    # * <tt>:username</tt>  -- Defaults to sa.
    # * <tt>:password</tt>  -- Defaults to empty string.
    # * <tt>:windows_auth</tt> -- Defaults to "User ID=#{username};Password=#{password}"
    #
    # ADO specific options:
    #
    # * <tt>:host</tt>      -- Defaults to localhost.
    # * <tt>:database</tt>  -- The name of the database. No default, must be provided.
    # * <tt>:windows_auth</tt> -- Use windows authentication instead of username/password.
    #
    # ODBC specific options:                   
    #
    # * <tt>:dsn</tt>       -- Defaults to nothing.
    #
    # ADO code tested on Windows 2000 and higher systems,
    # running ruby 1.8.2 (2004-07-29) [i386-mswin32], and SQL Server 2000 SP3.
    #
    # ODBC code tested on a Fedora Core 4 system, running FreeTDS 0.63, 
    # unixODBC 2.2.11, Ruby ODBC 0.996, Ruby DBI 0.0.23 and Ruby 1.8.2.
    # [Linux strongmad 2.6.11-1.1369_FC4 #1 Thu Jun 2 22:55:56 EDT 2005 i686 i686 i386 GNU/Linux]
    class SQLServerAdapter < AbstractAdapter
    
      def initialize(connection, logger, connection_options=nil)
        super(connection, logger)
        @connection_options = connection_options
      end

      def native_database_types
        {
          :primary_key => "int NOT NULL IDENTITY(1, 1) PRIMARY KEY",
          :string      => { :name => "varchar", :limit => 255  },
          :text        => { :name => "text" },
          :integer     => { :name => "int" },
          :float       => { :name => "float", :limit => 8 },
          :decimal     => { :name => "decimal" },
          :datetime    => { :name => "datetime" },
          :timestamp   => { :name => "datetime" },
          :time        => { :name => "datetime" },
          :date        => { :name => "datetime" },
          :binary      => { :name => "image"},
          :boolean     => { :name => "bit"}
        }
      end

      def adapter_name
        'SQLServer'
      end
      
      def supports_migrations? #:nodoc:
        true
      end

      def type_to_sql(type, limit = nil, precision = nil, scale = nil) #:nodoc:
        return super unless type.to_s == 'integer'

        if limit.nil? || limit == 4
          'integer'
        elsif limit < 4
          'smallint'
        else
          'bigint'
        end
      end

      # CONNECTION MANAGEMENT ====================================#

      # Returns true if the connection is active.
      def active?
        @connection.execute("SELECT 1").finish
        true
      rescue DBI::DatabaseError, DBI::InterfaceError
        false
      end

      # Reconnects to the database, returns false if no connection could be made.
      def reconnect!
        disconnect!
        @connection = DBI.connect(*@connection_options)
      rescue DBI::DatabaseError => e
        @logger.warn "#{adapter_name} reconnection failed: #{e.message}" if @logger
        false
      end
      
      # Disconnects from the database
      
      def disconnect!
        @connection.disconnect rescue nil
      end

      def select_rows(sql, name = nil)
        rows = []
        repair_special_columns(sql)
        log(sql, name) do
          @connection.select_all(sql) do |row|
            record = []
            row.each do |col|
              if col.is_a? DBI::Timestamp
                record << col.to_time
              else
                record << col
              end
            end
            rows << record
          end
        end
        rows
      end

      def columns(table_name, name = nil)
        return [] if table_name.blank?
        table_name = table_name.to_s if table_name.is_a?(Symbol)
        table_name = table_name.split('.')[-1] unless table_name.nil?
        table_name = table_name.gsub(/[\[\]]/, '')
        sql = %Q{
          SELECT 
            cols.COLUMN_NAME as ColName,  
            cols.COLUMN_DEFAULT as DefaultValue,
            cols.NUMERIC_SCALE as numeric_scale,
            cols.NUMERIC_PRECISION as numeric_precision, 
            cols.DATA_TYPE as ColType, 
            cols.IS_NULLABLE As IsNullable,  
            COL_LENGTH(cols.TABLE_NAME, cols.COLUMN_NAME) as Length,  
            COLUMNPROPERTY(OBJECT_ID(cols.TABLE_NAME), cols.COLUMN_NAME, 'IsIdentity') as IsIdentity,  
            cols.NUMERIC_SCALE as Scale 
          FROM INFORMATION_SCHEMA.COLUMNS cols 
          WHERE cols.TABLE_NAME = '#{table_name}'   
        }
        # Comment out if you want to have the Columns select statment logged.
        # Personally, I think it adds unnecessary bloat to the log. 
        # If you do comment it out, make sure to un-comment the "result" line that follows
        result = log(sql, name) { @connection.select_all(sql) }
        #result = @connection.select_all(sql)
        columns = []
        result.each do |field|
          default = field[:DefaultValue].to_s.gsub!(/[()\']/,"") =~ /null/i ? nil : field[:DefaultValue]
          if field[:ColType] =~ /numeric|decimal/i
            type = "#{field[:ColType]}(#{field[:numeric_precision]},#{field[:numeric_scale]})"
          else
            type = "#{field[:ColType]}(#{field[:Length]})"
          end
          is_identity = field[:IsIdentity] == 1
          is_nullable = field[:IsNullable] == 'YES'
          columns << SQLServerColumn.new(field[:ColName], default, type, is_identity, is_nullable)
        end
        columns
      end
      
      def empty_insert_statement(table_name)
        "INSERT INTO #{table_name} DEFAULT VALUES"
      end      

      def insert_sql(sql, name = nil, pk = nil, id_value = nil, sequence_name = nil)
        super || select_value("SELECT @@IDENTITY AS Ident")
      end

      def update_sql(sql, name = nil)          
        autoCommiting = @connection["AutoCommit"]
        begin
          begin_db_transaction if autoCommiting
          execute(sql, name)
          affectedRows = select_value("SELECT @@ROWCOUNT AS AffectedRows")
          commit_db_transaction if autoCommiting
          affectedRows
        rescue
          rollback_db_transaction if autoCommiting
          raise
        end                    
      end

      def execute(sql, name = nil)
        if sql =~ /^\s*INSERT/i && (table_name = query_requires_identity_insert?(sql))
          log(sql, name) do
            with_identity_insert_enabled(table_name) do 
              @connection.execute(sql) do |handle|
                yield(handle) if block_given?
              end
            end
          end
        else
          log(sql, name) do
            @connection.execute(sql) do |handle|
              yield(handle) if block_given?
            end
          end
        end
      end

      def begin_db_transaction
        @connection["AutoCommit"] = false
      rescue Exception => e
        @connection["AutoCommit"] = true
      end

      def commit_db_transaction
        @connection.commit
      ensure
        @connection["AutoCommit"] = true
      end

      def rollback_db_transaction
        @connection.rollback
      ensure
        @connection["AutoCommit"] = true
      end

      def quote(value, column = nil)
        return value.quoted_id if value.respond_to?(:quoted_id)

        case value
        when TrueClass             then '1'
        when FalseClass            then '0'
        else
          if value.acts_like?(:time)
            "'#{value.strftime("%Y%m%d %H:%M:%S")}'"
          elsif value.acts_like?(:date)
            "'#{value.strftime("%Y%m%d")}'"
          else
            super
          end
        end
      end

      def quote_string(string)
        string.gsub(/\'/, "''")
      end

      def quote_column_name(name)
        "[#{name}]"
      end

      def add_limit_offset!(sql, options)
        if options[:offset]
          raise ArgumentError, "offset should have a limit" unless options[:limit]
          unless options[:offset].kind_of?Integer
            if options[:offset] =~ /^\d+$/
              options[:offset] = options[:offset].to_i 
            else
              raise ArgumentError, "offset should be an integer"
            end
          end
        end

        if options[:limit] && !(options[:limit].kind_of?Integer)
          # is it just a string which should be an integer?
          if options[:limit] =~ /^\d+$/
            options[:limit] = options[:limit].to_i 
          else
            raise ArgumentError, "limit should be an integer"
          end
        end

        # limit/offset handling in SQL Server is complicated by the fact it has no support for offset or rowcount 
 	# Here's the strategy used instead: 
 	#   1) select limit + offset rows into a temporary table 
 	#   2) delete offset rows from temporary table 
 	#   3) select * from temporary table 
 	# This can't be achieved in a single SQL statement, so instead transform the query to do part 1, and then 
 	# in the select method grab the limit and offset to do parts 2 and 3 
 	# N.B. This should only happen if both limit and offset are specified, and offset is greater than 0.  In 
 	# other circumstances the query will proceed normally  	   
        if options[:limit] && options[:offset]  && options[:offset] > 0 
          sql.sub!(/^\s*SELECT(\s+DISTINCT)?/i) {"SELECT#{$1} TOP #{options[:limit] + options[:offset]} "} 
          sql.sub!(/ FROM /i, " INTO #limit_offset_temp -- limit => #{options[:limit]} offset => #{options[:offset]} \n FROM ") 
        elsif options[:limit] && (sql !~ /^\s*SELECT (@@|COUNT\()/i) 
          sql.sub!(/^\s*SELECT(\s+DISTINCT)?/i) {"SELECT#{$1} TOP #{options[:limit]} "} 
        end
      end

      def add_lock!(sql, options)
        @logger.info "Warning: SQLServer :lock option '#{options[:lock].inspect}' not supported" if @logger && options.has_key?(:lock)
        sql
      end

      def recreate_database(name)
        drop_database(name)
        create_database(name)
      end

      def drop_database(name)
        execute "DROP DATABASE #{name}"
      end

      def create_database(name)
        execute "CREATE DATABASE #{name}"
      end
   
      def current_database
        @connection.select_one("select DB_NAME()")[0]
      end

      def tables(name = nil)
        execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'", name) do |sth|
          result = sth.inject([]) do |tables, field|
            table_name = field[0]
            tables << table_name unless table_name == 'dtproperties'            
            tables
          end
        end
      end

      def indexes(table_name, name = nil)
        ActiveRecord::Base.connection.instance_variable_get("@connection")["AutoCommit"] = false
        __indexes(table_name, name)
      ensure
        ActiveRecord::Base.connection.instance_variable_get("@connection")["AutoCommit"] = true
      end
            
      def rename_table(name, new_name)
        execute "EXEC sp_rename '#{name}', '#{new_name}'"
      end

      def add_column(table_name, column_name, type, options = {})
        add_column_sql = "ALTER TABLE #{table_name} ADD #{quote_column_name(column_name)} #{type_to_sql(type, options[:limit], options[:precision], options[:scale])}"      
        add_column_options!(add_column_sql, options)
        # TODO: Add support to mimic date columns, using constraints to mark them as such in the database
        # add_column_sql << " CONSTRAINT ck__#{table_name}__#{column_name}__date_only CHECK ( CONVERT(CHAR(12), #{quote_column_name(column_name)}, 14)='00:00:00:000' )" if type == :date       
        execute(add_column_sql)
      end
       
      def rename_column(table, column, new_column_name)
        execute "EXEC sp_rename '#{table}.#{column}', '#{new_column_name}'"
      end
      
      def change_column(table_name, column_name, type, options = {}) #:nodoc:
        sql = "ALTER TABLE #{table_name} ALTER COLUMN #{quote_column_name(column_name)} #{type_to_sql(type, options[:limit], options[:precision], options[:scale])}"
        sql << " NOT NULL" if options[:null] == false
        sql_commands = [sql]        
        if options_include_default?(options)
          remove_default_constraint(table_name, column_name)
          sql_commands << "ALTER TABLE #{table_name} ADD CONSTRAINT DF_#{table_name}_#{column_name} DEFAULT #{quote(options[:default], options[:column])} FOR #{quote_column_name(column_name)}"
        end
        sql_commands.each {|c|
          execute(c)
        }
      end
      
      def change_column_default(table_name, column_name, default)
        remove_default_constraint(table_name, column_name)
        execute "ALTER TABLE #{table_name} ADD CONSTRAINT DF_#{table_name}_#{column_name} DEFAULT #{quote(default, column_name)} FOR #{quote_column_name(column_name)}"  
      end
      
      def remove_column(table_name, column_name)
        remove_check_constraints(table_name, column_name)
        remove_default_constraint(table_name, column_name)
        remove_indexes(table_name, column_name)
        execute "ALTER TABLE [#{table_name}] DROP COLUMN #{quote_column_name(column_name)}"
      end
      
      def remove_default_constraint(table_name, column_name)
        constraints = select "select def.name from sysobjects def, syscolumns col, sysobjects tab where col.cdefault = def.id and col.name = '#{column_name}' and tab.name = '#{table_name}' and col.id = tab.id"
        
        constraints.each do |constraint|
          execute "ALTER TABLE #{table_name} DROP CONSTRAINT #{constraint["name"]}"
        end
      end
      
      def remove_check_constraints(table_name, column_name)
        # TODO remove all constraints in single method
        constraints = select "SELECT CONSTRAINT_NAME FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_NAME = '#{table_name}' and COLUMN_NAME = '#{column_name}'"
        constraints.each do |constraint|
          execute "ALTER TABLE #{table_name} DROP CONSTRAINT #{constraint["CONSTRAINT_NAME"]}"
        end
      end
      
      def remove_indexes(table_name, column_name)
        __indexes(table_name).select {|idx| idx.columns.include? column_name }.each do |idx|
          remove_index(table_name, {:name => idx.name})
        end
      end
      
      def remove_index(table_name, options = {})
        execute "DROP INDEX #{table_name}.#{quote_column_name(index_name(table_name, options))}"
      end

      private
      def __indexes(table_name, name = nil)
        indexes = []        
        execute("EXEC sp_helpindex '#{table_name}'", name) do |handle|
          if handle.column_info.any?
            handle.each do |index| 
              unique = index[1] =~ /unique/
              primary = index[1] =~ /primary key/
              if !primary
                indexes << IndexDefinition.new(table_name, index[0], unique, index[2].split(", ").map {|e| e.gsub('(-)','')})
              end
            end
          end
        end
        indexes
      end
      
      def select(sql, name = nil)
        repair_special_columns(sql)
        
        if sql.match(/SELECT DISTINCT/) 
          sql.gsub!(/DISTINCT/, '') unless order_by_in_select_list?(sql) 
        end
        
        if match = query_has_limit_and_offset?(sql) 
          matched, limit, offset = *match 
          select_with_offset(sql, limit, offset)          
        else 
          select_without_offset(sql)
        end        
      end
      
      def order_by_in_select_list?(sql)
        match = sql.match(/SELECT DISTINCT (TOP \d+) (.*) FROM .* ORDER BY (.*) (ASC|DESC)/i)
        matched, top, select, order_by = *match
        select.gsub!(/[\[\]]/, '')
        order_by.gsub!(/[\[\]]/, '')
        select.split(',').each do |select_field|
          return true if order_by.include? select_field
        end
        return false
      end
      
      def query_has_limit_and_offset?(sql) 
        match = sql.match(/#limit_offset_temp -- limit => (\d+) offset => (\d+)/) 
      end 
      
      def select_with_offset(sql, limit, offset, name = nil)
        execute(sql) 
        # SET ROWCOUNT n causes all statements to only affect n rows, which we use 
        # to delete offset rows from the temporary table 
        execute("SET ROWCOUNT #{offset}") 
        execute("DELETE from #limit_offset_temp") 
        execute("SET ROWCOUNT 0") 
        result = select_without_offset("SELECT * FROM #limit_offset_temp") 
        execute("DROP TABLE #limit_offset_temp") 
        result 
      end      
      
      def select_without_offset(sql, name = nil)
        result = []          
        execute(sql) do |handle|
          handle.each do |row|
            row_hash = {}
            row.each_with_index do |value, i|
              if value.is_a? DBI::Timestamp
                value = DateTime.new(value.year, value.month, value.day, value.hour, value.minute, value.sec)
              end
              row_hash[handle.column_names[i]] = value
            end
            result << row_hash
          end
        end
        result
      end

      # Turns IDENTITY_INSERT ON for table during execution of the block
      # N.B. This sets the state of IDENTITY_INSERT to OFF after the
      # block has been executed without regard to its previous state

      def with_identity_insert_enabled(table_name, &block)
        set_identity_insert(table_name, true)
        yield
      ensure
        set_identity_insert(table_name, false)  
      end
        
      def set_identity_insert(table_name, enable = true)
        execute "SET IDENTITY_INSERT #{table_name} #{enable ? 'ON' : 'OFF'}"
      rescue Exception => e
        raise ActiveRecordError, "IDENTITY_INSERT could not be turned #{enable ? 'ON' : 'OFF'} for table #{table_name}"  
      end

      def get_table_name(sql)
        if sql =~ /^\s*insert\s+into\s+([^\(\s]+)\s*|^\s*update\s+([^\(\s]+)\s*/i
          $1
        elsif sql =~ /from\s+([^\(\s]+)\s*/i
          $1
        else
          nil
        end
      end

      def identity_column(table_name)
        @table_columns = {} unless @table_columns
        @table_columns[table_name] = columns(table_name) if @table_columns[table_name] == nil
        @table_columns[table_name].each do |col|
          return col.name if col.identity
        end

        return nil
      end

      def query_requires_identity_insert?(sql)
        table_name = get_table_name(sql)
        id_column = identity_column(table_name)
        sql =~ /\[#{id_column}\]/ ? table_name : nil
      end

      def change_order_direction(order)
        order.split(",").collect {|fragment|
          case fragment
          when  /\bDESC\b/i     then fragment.gsub(/\bDESC\b/i, "ASC")
          when  /\bASC\b/i      then fragment.gsub(/\bASC\b/i, "DESC")
          else                  String.new(fragment).split(',').join(' DESC,') + ' DESC'
          end
        }.join(",")
      end

      def get_special_columns(table_name)
        special = []
        @table_columns ||= {}
        @table_columns[table_name] ||= columns(table_name)
        @table_columns[table_name].each do |col|
          special << col.name if col.is_special
        end
        special
      end

      def repair_special_columns(sql)
        special_cols = get_special_columns(get_table_name(sql))
        for col in special_cols.to_a
          sql.gsub!(/((\.|\s|\()\[?#{col.to_s}\]?)\s?=\s?/, '\1 LIKE ')
          sql.gsub!(/ORDER BY #{col.to_s}/i, '')
        end
        sql
      end

    end #class SQLServerAdapter < AbstractAdapter
  end #module ConnectionAdapters
end #module ActiveRecord

#  
#  module ConnectionAdapters
#    class SQLServerColumn < Column# :nodoc:
#      attr_reader :identity, :is_special
#
#      def initialize(name, default, sql_type = nil, identity = false, null = true) # TODO: check ok to remove scale_value = 0
#        super(name, default, sql_type, null)
#        @identity = identity
#        @is_special = sql_type =~ /text|ntext|image/i
#        # TODO: check ok to remove @scale = scale_value
#        # SQL Server only supports limits on *char and float types
#        @limit = nil unless @type == :float or @type == :string
#      end
#
#      def simplified_type(field_type)
#        case field_type
#        when /real/i              then :float
#        when /money/i             then :decimal
#        when /image/i             then :binary
#        when /bit/i               then :boolean
#        when /uniqueidentifier/i  then :string
#        else super
#        end
#      end
#
#      def type_cast(value)
#        return nil if value.nil?
#        case type
#        when :datetime  then cast_to_datetime(value)
#        when :timestamp then cast_to_time(value)
#        when :time      then cast_to_time(value)
#        when :date      then cast_to_datetime(value)
#        when :boolean   then value == true or (value =~ /^t(rue)?$/i) == 0 or value.to_s == '1'
#        else super
#        end
#      end
#      
#      def cast_to_time(value)
#        return value if value.is_a?(Time)        
#        time_array = value.is_a?(Array) ? value : ParseDate.parsedate(value)        
#        Time.send(Base.default_timezone, *time_array) rescue nil
#      end
#
#      def cast_to_datetime(value)
#        return value.to_time if value.is_a?(DBI::Timestamp)
#        
#        if value.is_a?(Time)
#          if value.year != 0 and value.month != 0 and value.day != 0
#            return value
#          else
#            return Time.mktime(2000, 1, 1, value.hour, value.min, value.sec) rescue nil
#          end
#        end
#   
#        if value.is_a?(DateTime)
#          return Time.mktime(value.year, value.mon, value.day, value.hour, value.min, value.sec)
#        end
#        
#        return cast_to_time(value) if value.is_a?(Date) or value.is_a?(String) rescue nil
#        value
#      end
#      
#      # TODO: Find less hack way to convert DateTime objects into Times
#      
#      def self.string_to_time(value)
#        if value.is_a?(DateTime)
#          return Time.mktime(value.year, value.mon, value.day, value.hour, value.min, value.sec)
#        else
#          super
#        end
#      end
#
#      # These methods will only allow the adapter to insert binary data with a length of 7K or less
#      # because of a SQL Server statement length policy.
#      def self.string_to_binary(value)
#        value.gsub(/(\r|\n|\0|\x1a)/) do
#          case $1
#          when "\r"   then  "%00"
#          when "\n"   then  "%01"
#          when "\0"   then  "%02"
#          when "\x1a" then  "%03"
#          end
#        end
#      end
#
#      def self.binary_to_string(value)
#        value.gsub(/(%00|%01|%02|%03)/) do
#          case $1
#          when "%00"    then  "\r"
#          when "%01"    then  "\n"
#          when "%02\0"  then  "\0"
#          when "%03"    then  "\x1a"
#          end
#        end
#      end
#    end
#
#    # In ADO mode, this adapter will ONLY work on Windows systems, 
#    # since it relies on Win32OLE, which, to my knowledge, is only 
#    # available on Windows.
#    #
#    # This mode also relies on the ADO support in the DBI module. If you are using the
#    # one-click installer of Ruby, then you already have DBI installed, but
#    # the ADO module is *NOT* installed. You will need to get the latest
#    # source distribution of Ruby-DBI from http://ruby-dbi.sourceforge.net/
#    # unzip it, and copy the file 
#    # <tt>src/lib/dbd_ado/ADO.rb</tt> 
#    # to
#    # <tt>X:/Ruby/lib/ruby/site_ruby/1.8/DBD/ADO/ADO.rb</tt> 
#    # (you will more than likely need to create the ADO directory).
#    # Once you've installed that file, you are ready to go.
#    #
#    # In ODBC mode, the adapter requires the ODBC support in the DBI module which requires
#    # the Ruby ODBC module.  Ruby ODBC 0.996 was used in development and testing,
#    # and it is available at http://www.ch-werner.de/rubyodbc/
#    #
#    # Options:
#    #
#    # * <tt>:mode</tt>      -- ADO or ODBC. Defaults to ADO.
#    # * <tt>:username</tt>  -- Defaults to sa.
#    # * <tt>:password</tt>  -- Defaults to empty string.
#    # * <tt>:windows_auth</tt> -- Defaults to "User ID=#{username};Password=#{password}"
#    #
#    # ADO specific options:
#    #
#    # * <tt>:host</tt>      -- Defaults to localhost.
#    # * <tt>:database</tt>  -- The name of the database. No default, must be provided.
#    # * <tt>:windows_auth</tt> -- Use windows authentication instead of username/password.
#    #
#    # ODBC specific options:                   
#    #
#    # * <tt>:dsn</tt>       -- Defaults to nothing.
#    #
#    # ADO code tested on Windows 2000 and higher systems,
#    # running ruby 1.8.2 (2004-07-29) [i386-mswin32], and SQL Server 2000 SP3.
#    #
#    # ODBC code tested on a Fedora Core 4 system, running FreeTDS 0.63, 
#    # unixODBC 2.2.11, Ruby ODBC 0.996, Ruby DBI 0.0.23 and Ruby 1.8.2.
#    # [Linux strongmad 2.6.11-1.1369_FC4 #1 Thu Jun 2 22:55:56 EDT 2005 i686 i686 i386 GNU/Linux]
#    class SQLServerAdapter < AbstractAdapter
#    
#      def initialize(connection, logger, connection_options=nil)
#        super(connection, logger)
#        @connection_options = connection_options
#      end
#
#      def native_database_types
#        {
#          :primary_key => "int NOT NULL IDENTITY(1, 1) PRIMARY KEY",
#          :string      => { :name => "varchar", :limit => 255  },
#          :text        => { :name => "text" },
#          :integer     => { :name => "int" },
#          :float       => { :name => "float", :limit => 8 },
#          :decimal     => { :name => "decimal" },
#          :datetime    => { :name => "datetime" },
#          :timestamp   => { :name => "datetime" },
#          :time        => { :name => "datetime" },
#          :date        => { :name => "datetime" },
#          :binary      => { :name => "image"},
#          :boolean     => { :name => "bit"}
#        }
#      end
#
#      def adapter_name
#        'SQLServer'
#      end
#      
#      def supports_migrations? #:nodoc:
#        true
#      end
#
#      def type_to_sql(type, limit = nil, precision = nil, scale = nil) #:nodoc:
#        return super unless type.to_s == 'integer'
#
#        if limit.nil? || limit == 4
#          'integer'
#        elsif limit < 4
#          'smallint'
#        else
#          'bigint'
#        end
#      end
#
#      # CONNECTION MANAGEMENT ====================================#
#
#      # Returns true if the connection is active.
#      def active?
#        @connection.execute("SELECT 1").finish
#        true
#      rescue DBI::DatabaseError, DBI::InterfaceError
#        false
#      end
#
#      # Reconnects to the database, returns false if no connection could be made.
#      def reconnect!
#        disconnect!
#        @connection = DBI.connect(*@connection_options)
#      rescue DBI::DatabaseError => e
#        @logger.warn "#{adapter_name} reconnection failed: #{e.message}" if @logger
#        false
#      end
#      
#      # Disconnects from the database
#      
#      def disconnect!
#        @connection.disconnect rescue nil
#      end
#
#      def select_rows(sql, name = nil)
#        rows = []
#        repair_special_columns(sql)
#        log(sql, name) do
#          @connection.select_all(sql) do |row|
#            record = []
#            row.each do |col|
#              if col.is_a? DBI::Timestamp
#                record << col.to_time
#              else
#                record << col
#              end
#            end
#            rows << record
#          end
#        end
#        rows
#      end
#
#      def columns(table_name, name = nil)
#        return [] if table_name.blank?
#        table_name = table_name.to_s if table_name.is_a?(Symbol)
#        table_name = table_name.split('.')[-1] unless table_name.nil?
#        table_name = table_name.gsub(/[\[\]]/, '')
#        sql = %Q{
#          SELECT 
#            cols.COLUMN_NAME as ColName,  
#            cols.COLUMN_DEFAULT as DefaultValue,
#            cols.NUMERIC_SCALE as numeric_scale,
#            cols.NUMERIC_PRECISION as numeric_precision, 
#            cols.DATA_TYPE as ColType, 
#            cols.IS_NULLABLE As IsNullable,  
#            COL_LENGTH(cols.TABLE_NAME, cols.COLUMN_NAME) as Length,  
#            COLUMNPROPERTY(OBJECT_ID(cols.TABLE_NAME), cols.COLUMN_NAME, 'IsIdentity') as IsIdentity,  
#            cols.NUMERIC_SCALE as Scale 
#          FROM INFORMATION_SCHEMA.COLUMNS cols 
#          WHERE cols.TABLE_NAME = '#{table_name}'   
#        }
#        # Comment out if you want to have the Columns select statment logged.
#        # Personally, I think it adds unnecessary bloat to the log. 
#        # If you do comment it out, make sure to un-comment the "result" line that follows
#        result = log(sql, name) { @connection.select_all(sql) }
#        #result = @connection.select_all(sql)
#        columns = []
#        result.each do |field|
#          default = field[:DefaultValue].to_s.gsub!(/[()\']/,"") =~ /null/ ? nil : field[:DefaultValue]
#          if field[:ColType] =~ /numeric|decimal/i
#            type = "#{field[:ColType]}(#{field[:numeric_precision]},#{field[:numeric_scale]})"
#          else
#            type = "#{field[:ColType]}(#{field[:Length]})"
#          end
#          is_identity = field[:IsIdentity] == 1
#          is_nullable = field[:IsNullable] == 'YES'
#          columns << SQLServerColumn.new(field[:ColName], default, type, is_identity, is_nullable)
#        end
#        columns
#      end
#
#      def insert_sql(sql, name = nil, pk = nil, id_value = nil, sequence_name = nil)
#        super || select_value("SELECT @@IDENTITY AS ident")
#      end
#
#      def update_sql(sql, name = nil)
#        execute(sql, name) do |handle|
#          handle.rows
#        end || select_value("SELECT @@ROWCOUNT AS affectedrows")
#      end
#
#      def execute(sql, name = nil)
#        if sql =~ /^\s*INSERT/i && (table_name = query_requires_identity_insert?(sql))
#          log(sql, name) do
#            with_identity_insert_enabled(table_name) do 
#              @connection.execute(sql) do |handle|
#                yield(handle) if block_given?
#              end
#            end
#          end
#        else
#          log(sql, name) do
#            @connection.execute(sql) do |handle|
#              yield(handle) if block_given?
#            end
#          end
#        end
#      end
#
#      def begin_db_transaction
#        @connection["AutoCommit"] = false
#      rescue Exception => e
#        @connection["AutoCommit"] = true
#      end
#
#      def commit_db_transaction
#        @connection.commit
#      ensure
#        @connection["AutoCommit"] = true
#      end
#
#      def rollback_db_transaction
#        @connection.rollback
#      ensure
#        @connection["AutoCommit"] = true
#      end
#
#      def quote(value, column = nil)
#        return value.quoted_id if value.respond_to?(:quoted_id)
#
#        case value
#        when TrueClass             then '1'
#        when FalseClass            then '0'
#        else
#          if value.acts_like?(:time)
#            "'#{value.strftime("%Y%m%d %H:%M:%S")}'"
#          elsif value.acts_like?(:date)
#            "'#{value.strftime("%Y%m%d")}'"
#          else
#            super
#          end
#        end
#      end
#
#      def quote_string(string)
#        string.gsub(/\'/, "''")
#      end
#
#      def quote_column_name(name)
#        "[#{name}]"
#      end
#
#      def add_limit_offset!(sql, options)
#        #        if options[:limit] and options[:offset]
#        #          total_rows = @connection.select_all("SELECT count(*) as totalrows from (#{sql.gsub(/\bSELECT(\s+DISTINCT)?\b/i, "SELECT#{$1} TOP 1000000000")}) tally")[0][:totalrows].to_i
#        #          if (options[:limit] + options[:offset]) >= total_rows
#        #            options[:limit] = (total_rows - options[:offset] >= 0) ? (total_rows - options[:offset]) : 0
#        #          end
#        #          sql.sub!(/^\s*SELECT(\s+DISTINCT)?/i, "SELECT * FROM (SELECT TOP #{options[:limit]} * FROM (SELECT#{$1} TOP #{options[:limit] + options[:offset]} ")
#        #          sql << ") AS tmp1"
#        #          if options[:order]
#        #            order = options[:order].split(',').map do |field|
#        #              parts = field.split(" ")
#        #              tc = parts[0]
#        #              if sql =~ /\.\[/ and tc =~ /\./ # if column quoting used in query
#        #                tc.gsub!(/\./, '\\.\\[')
#        #                tc << '\\]'
#        #              end
#        #              if sql =~ /#{tc} AS (t\d_r\d\d?)/
#        #                parts[0] = $1
#        #              elsif parts[0] =~ /\w+\.(\w+)/
#        #                parts[0] = $1
#        #              end
#        #              parts.join(' ')
#        #            end.join(', ')
#        #            sql << " ORDER BY #{change_order_direction(order)}) AS tmp2 ORDER BY #{order}"
#        #          else
#        #            sql << " ) AS tmp2"
#        #          end
#        #        elsif sql !~ /^\s*SELECT (@@|COUNT\()/i
#        #          sql.sub!(/^\s*SELECT(\s+DISTINCT)?/i) do
#        #            "SELECT#{$1} TOP #{options[:limit]}"
#        #          end unless options[:limit].nil?
#
#        # limit/offset handling in SQL Server is complicated by the fact it has no support for offset or rowcount 
# 	# Here's the strategy used instead: 
# 	#   1) select limit + offset rows into a temporary table 
# 	#   2) delete offset rows from temporary table 
# 	#   3) select * from temporary table 
# 	# This can't be achieved in a single SQL statement, so instead transform the query to do part 1, and then 
# 	# in the select method grab the limit and offset to do parts 2 and 3 
# 	# N.B. This should only happen if both limit and offset are specified, and offset is greater than 0.  In 
# 	# other circumstances the query will proceed normally  	   
#        if options[:limit] && options[:offset]  && options[:offset] > 0 
#          sql.sub!(/^\s*SELECT(\s+DISTINCT)?/i) {"SELECT#{$1} TOP #{options[:limit] + options[:offset]} "} 
#          sql.sub!(/ FROM /i, " INTO #limit_offset_temp -- limit => #{options[:limit]} offset => #{options[:offset]} \n FROM ") 
#        elsif options[:limit] && (sql !~ /^\s*SELECT (@@|COUNT\()/i) 
#          sql.sub!(/^\s*SELECT(\s+DISTINCT)?/i) {"SELECT#{$1} TOP #{options[:limit]} "} 
#        end
#      end
#
#      def recreate_database(name)
#        drop_database(name)
#        create_database(name)
#      end
#
#      def drop_database(name)
#        execute "DROP DATABASE #{name}"
#      end
#
#      def create_database(name)
#        execute "CREATE DATABASE #{name}"
#      end
#   
#      def current_database
#        @connection.select_one("select DB_NAME()")[0]
#      end
#
#      def tables(name = nil)
#        execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'", name) do |sth|
#          result = sth.inject([]) do |tables, field|
#            table_name = field[0]
#            tables << table_name unless table_name == 'dtproperties'            
#            tables
#          end
#        end
#      end
#
#      def indexes(table_name, name = nil)
#        ActiveRecord::Base.connection.instance_variable_get("@connection")["AutoCommit"] = false
#        indexes = []        
#        execute("EXEC sp_helpindex '#{table_name}'", name) do |handle|
#          if handle.column_info.any?
#            handle.each do |index| 
#              unique = index[1] =~ /unique/
#              primary = index[1] =~ /primary key/
#              if !primary
#                indexes << IndexDefinition.new(table_name, index[0], unique, index[2].split(", ").map {|e| e.gsub('(-)','')})
#              end
#            end
#          end
#        end
#        indexes
#      ensure
#        ActiveRecord::Base.connection.instance_variable_get("@connection")["AutoCommit"] = true
#      end
#            
#      def rename_table(name, new_name)
#        execute "EXEC sp_rename '#{name}', '#{new_name}'"
#      end
#      
#      # Adds a new column to the named table.
#      # See TableDefinition#column for details of the options you can use.
#      def add_column(table_name, column_name, type, options = {})
#        add_column_sql = "ALTER TABLE #{table_name} ADD #{quote_column_name(column_name)} #{type_to_sql(type, options[:limit], options[:precision], options[:scale])}"
#        add_column_options!(add_column_sql, options)
#        # TODO: Add support to mimic date columns, using constraints to mark them as such in the database
#        # add_column_sql << " CONSTRAINT ck__#{table_name}__#{column_name}__date_only CHECK ( CONVERT(CHAR(12), #{quote_column_name(column_name)}, 14)='00:00:00:000' )" if type == :date       
#        execute(add_column_sql)
#      end
#       
#      def rename_column(table, column, new_column_name)
#        execute "EXEC sp_rename '#{table}.#{column}', '#{new_column_name}'"
#      end
#      
#      def change_column(table_name, column_name, type, options = {}) #:nodoc:
#        sql_commands = ["ALTER TABLE #{table_name} ALTER COLUMN #{column_name} #{type_to_sql(type, options[:limit], options[:precision], options[:scale])}"]
#        if options_include_default?(options)
#          remove_default_constraint(table_name, column_name)
#          sql_commands << "ALTER TABLE #{table_name} ADD CONSTRAINT DF_#{table_name}_#{column_name} DEFAULT #{quote(options[:default], options[:column])} FOR #{column_name}"
#        end
#        sql_commands.each {|c|
#          execute(c)
#        }
#      end
#      
#      def change_column_default(table_name, column_name, default)
#        remove_default_constraint(table_name, column_name)
#        execute "ALTER TABLE #{table_name} ADD CONSTRAINT DF_#{table_name}_#{column_name} DEFAULT #{quote(default, column_name)} FOR #{column_name}"   
#      end
#      
#      def remove_column(table_name, column_name)
#        remove_check_constraints(table_name, column_name)
#        remove_default_constraint(table_name, column_name)
#        execute "ALTER TABLE [#{table_name}] DROP COLUMN [#{column_name}]"
#      end
#      
#      def remove_default_constraint(table_name, column_name)
#        constraints = select "select def.name from sysobjects def, syscolumns col, sysobjects tab where col.cdefault = def.id and col.name = '#{column_name}' and tab.name = '#{table_name}' and col.id = tab.id"
#        
#        constraints.each do |constraint|
#          execute "ALTER TABLE #{table_name} DROP CONSTRAINT #{constraint["name"]}"
#        end
#      end
#      
#      def remove_check_constraints(table_name, column_name)
#        # TODO remove all constraints in single method
#        constraints = select "SELECT CONSTRAINT_NAME FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_NAME = '#{table_name}' and COLUMN_NAME = '#{column_name}'"
#        constraints.each do |constraint|
#          execute "ALTER TABLE #{table_name} DROP CONSTRAINT #{constraint["CONSTRAINT_NAME"]}"
#        end
#      end
#      
#      def remove_index(table_name, options = {})
#        execute "DROP INDEX #{table_name}.#{quote_column_name(index_name(table_name, options))}"
#      end
#
#      private 
#      def select(sql, name = nil)
#        repair_special_columns(sql)
#
#        #        result = []          
#        #        execute(sql) do |handle|
#        #          handle.each do |row|
#        if match = query_has_limit_and_offset?(sql) 
#          matched, limit, offset = *match 
#          execute(sql) 
#          # SET ROWCOUNT n causes all statements to only affect n rows, which we use 
#          # to delete offset rows from the temporary table 
#          execute("SET ROWCOUNT #{offset}") 
#          execute("DELETE from #limit_offset_temp") 
#          execute("SET ROWCOUNT 0") 
#          result = execute_select("SELECT * FROM #limit_offset_temp") 
#          execute("DROP TABLE #limit_offset_temp") 
#          result 
#        else 
#          execute_select(sql) 
#        end 
#      end 
# 		         
#      def execute_select(sql) 
#        result = []           
#        execute(sql) do |handle| 
#          handle.each do |row| 
#            row_hash = {}
#            row.each_with_index do |value, i|
#              if value.is_a? DBI::Timestamp
#                value = DateTime.new(value.year, value.month, value.day, value.hour, value.minute, value.sec)
#              end
#              row_hash[handle.column_names[i].downcase] = value
#            end
#            result << row_hash
#          end
#        end
#        result
#      end
#      
#      def query_has_limit_and_offset?(sql) 
#        match = sql.match(/#limit_offset_temp -- limit => (\d+) offset => (\d+)/) 
#      end 
#
#      # Turns IDENTITY_INSERT ON for table during execution of the block
#      # N.B. This sets the state of IDENTITY_INSERT to OFF after the
#      # block has been executed without regard to its previous state
#
#      def with_identity_insert_enabled(table_name, &block)
#        set_identity_insert(table_name, true)
#        yield
#      ensure
#        set_identity_insert(table_name, false)  
#      end
#        
#      def set_identity_insert(table_name, enable = true)
#        execute "SET IDENTITY_INSERT #{table_name} #{enable ? 'ON' : 'OFF'}"
#      rescue Exception => e
#        raise ActiveRecordError, "IDENTITY_INSERT could not be turned #{enable ? 'ON' : 'OFF'} for table #{table_name}"  
#      end
#
#      def get_table_name(sql)
#        if sql =~ /^\s*insert\s+into\s+([^\(\s]+)\s*|^\s*update\s+([^\(\s]+)\s*/i
#          $1
#        elsif sql =~ /from\s+([^\(\s]+)\s*/i
#          $1
#        else
#          nil
#        end
#      end
#
#      def identity_column(table_name)
#        @table_columns = {} unless @table_columns
#        @table_columns[table_name] = columns(table_name) if @table_columns[table_name] == nil
#        @table_columns[table_name].each do |col|
#          return col.name if col.identity
#        end
#
#        return nil
#      end
#
#      def query_requires_identity_insert?(sql)
#        table_name = get_table_name(sql)
#        id_column = identity_column(table_name)
#        sql =~ /\[#{id_column}\]/ ? table_name : nil
#      end
#
#      def change_order_direction(order)
#        order.split(",").collect {|fragment|
#          case fragment
#          when  /\bDESC\b/i     then fragment.gsub(/\bDESC\b/i, "ASC")
#          when  /\bASC\b/i      then fragment.gsub(/\bASC\b/i, "DESC")
#          else                  String.new(fragment).split(',').join(' DESC,') + ' DESC'
#          end
#        }.join(",")
#      end
#
#      def get_special_columns(table_name)
#        special = []
#        @table_columns ||= {}
#        @table_columns[table_name] ||= columns(table_name)
#        @table_columns[table_name].each do |col|
#          special << col.name if col.is_special
#        end
#        special
#      end
#
#      def repair_special_columns(sql)
#        special_cols = get_special_columns(get_table_name(sql))
#        for col in special_cols.to_a
#          sql.gsub!(Regexp.new(" #{col.to_s} = "), " #{col.to_s} LIKE ")
#          sql.gsub!(/ORDER BY #{col.to_s}/i, '')
#        end
#        sql
#      end
#
#    end #class SQLServerAdapter < AbstractAdapter
#  end #module ConnectionAdapters
#end #module ActiveRecord
