require File.join('active_record', 'connection_adapters', 'sqlserver_adapter') 
require File.join(File.dirname(__FILE__), 'lib', 'ms_access')
require File.join(File.dirname(__FILE__), 'lib', 'nullify_processor')

options = { :rails_root => RAILS_ROOT }

ETL::Engine.init options
ETL::Engine.realtime_activity = true