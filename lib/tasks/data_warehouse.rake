namespace :data_warehouse do     
  desc "import tables from aquatic data warehouse"
  task :import => :environment do
    init_etl
    puts "Starting ETL process"
    ETL::Engine.process File.join(RAILS_ROOT, 'db', 'etl', 'import.ebf')
    puts "ETL process complete"
  end  

  desc "transform water chemistry analysis row into water measurement rows"  
  task :samples => :environment do
    init_etl
    ETL::Engine.process File.join(RAILS_ROOT, 'db', 'etl', 'samples.ebf')
  end  
  
  desc "export all"
  task :export => :environment do 
    
  end
end

def init_etl(options = {})
  require File.join(RAILS_ROOT, 'vendor', 'plugins', 'etl', 'lib', 'etl')
  require 'etl_engine_logger_mod'
  require 'active_record/connection_adapters/sqlserver_adapter'   
  options = { :rails_root => RAILS_ROOT }.merge(options)
  ETL::Engine.init options
  ETL::Engine.realtime_activity = true
end