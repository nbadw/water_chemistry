namespace :import do 
  desc "imports drainage unit data from sql server"
  task :drainage_units => :environment do      
    import_from :table => 'tblDrainageUnit', :primary_key => 'drainagecd'
  end

  desc "imports water temperature logger data from sql server"
  task :temperature_loggers => :environment do
    import_from :table => 'tblWaterTemperatureLoggerDetails', :primary_key => 'TemperatureLoggerID'
  end

  desc "imports waterbody data from sql server"
  task :waterbodies => :environment do
    import_from :table => 'tblWaterBody', :primary_key => 'WaterBodyID'
  end
end

def import_from(options = {})
  options[:table] = options[:table].downcase
  options[:primary_key] = options[:primary_key].downcase
  
  puts 'connecting to export db'
  # create an active record connection to the sqlserver database
  ActiveRecord::Base.establish_connection({
      'adapter' => 'sqlserver', 
      'database' => 'dataWarehouse_dev',
      'host' => '.\SQLEXPRESS',
      'provider' => 'SQLNCLI',
      'windows_auth' => true 
    })    
  require "#{RAILS_ROOT}/lib/sqlserver_adapter"
    
  export_table = Class.new(ActiveRecord::Base) do
    set_table_name  options[:table]
    set_primary_key options[:primary_key] if options.has_key?(:primary_key)
  end
    
  puts 'reading data from export table: ' + options[:table]
  columns = export_table.columns
  rows    = export_table.find :all
  puts "#{rows.size} records ready for import"
    
  puts 'connecting to import db'
  # create an active record connection to the postgres database
  ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
    
  puts 'dropping existing import table: ' + options[:table]
  #drop in case it already exists
  begin
    ActiveRecord::Schema.drop_table(options[:table])
  rescue
  end 
    
  puts 'creating import table: ' + options[:table]
  #empty block : the columns will be added afterwards
  ActiveRecord::Schema.create_table(options[:table], :primary_key => options[:primary_key] || 'id') { }    
    
  columns.each do |col|
    ActiveRecord::Schema.add_column(options[:table], col.name, col.type, {
        :limit     => col.limit,
        :null      => col.null,
        :precision => col.precision,
        :scale     => col.scale,
        :default   => col.default
      }) unless col.name == options[:primary_key]
  end
    
  import_table = Class.new(ActiveRecord::Base) do
    set_table_name  options[:table]
    set_primary_key options[:primary_key] if options.has_key?(:primary_key)
  end

  puts 'importing data...'
  import_table.transaction do
    rows.each_with_index do |row, i|      
      puts "#{i.to_f / rows.size.to_f * 100.to_f}%"
      record = import_table.new(row.attributes)
      record.id = row.id
      begin
        record.save!
      rescue Exception => e
        'ERROR: ' + e.message + ' , record: ' + record.inspect
      end
    end
  end
    
  puts 'done'
end