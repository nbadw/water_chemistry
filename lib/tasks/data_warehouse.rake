ETL_ROOT = File.join(RAILS_ROOT, 'db', 'etl')

namespace :data_warehouse do 
  task :initialize_etl_engine => :environment do    
    initialize_etl_engine
  end 
    
  desc "run all import scripts"
  task :import do
    Rake::Task['data_warehouse:import:all'].invoke
  end
  
  namespace :import do 
    task :init do
      Rake::Task['data_warehouse:initialize_etl_engine'].invoke
    end
    
    task :all => [:agencies, :aquatic_activities, :aquatic_activity_events, :aquatic_activity_methods,
      :aquatic_site_usages, :aquatic_sites, :instruments, :observations, :observable_values,
      :measurements, :measurement_instrument, :measurement_unit, :units_of_measure, :waterbodies
    ]

    desc "import agencies"
    task :agencies => :init do
      process File.join(ETL_ROOT, 'import', 'agencies.ctl')
    end
    
    desc "build code->id decode file for agencies"
    task :agency_code_to_id => :agencies do
      process File.join(ETL_ROOT, 'import', 'agency_code_to_id.ctl')
    end
    
    desc "import aquatic activities"
    task :aquatic_activities => :init do
      process File.join(ETL_ROOT, 'import', 'aquatic_activities.ctl')
    end
    
    desc "import aquatic activity events"
    task :aquatic_activity_events => :agency_code_to_id do
      process File.join(ETL_ROOT, 'import', 'aquatic_activity_events.ctl')
    end
    
    desc "import aquatic activity methods"
    task :aquatic_activity_methods => :init do
      process File.join(ETL_ROOT, 'import', 'aquatic_activity_methods.ctl')
    end    
    
    desc "import aquatic site usages"
    task :aquatic_site_usages => :agency_code_to_id do
      process File.join(ETL_ROOT, 'import', 'aquatic_site_usages.ctl')
    end
    
    desc "import aquatic sites"
    task :aquatic_sites => :init do
      process File.join(ETL_ROOT, 'import', 'aquatic_sites.ctl')
    end
    
    desc "import instruments"
    task :instruments => :init do
      process File.join(ETL_ROOT, 'import', 'instruments.ctl')
    end
    
    desc "import observations"
    task :observations => :init do
      process File.join(ETL_ROOT, 'import', 'observations.ctl')
    end   

    desc "import observable values"
    task :observable_values => :init do
      process File.join(ETL_ROOT, 'import', 'observable_values.ctl')
    end 
    
    desc "import measurements"
    task :measurements => :init do
      process File.join(ETL_ROOT, 'import', 'measurements.ctl')
    end
    
    desc "import measurement->instrument join table"
    task :measurement_instrument => [:measurements, :instruments] do
      process File.join(ETL_ROOT, 'import', 'measurement_instrument.ctl')
    end
    
    desc "import measurement->unit join table"
    task :measurement_unit => [:measurements, :units_of_measure] do
      process File.join(ETL_ROOT, 'import', 'measurement_unit.ctl')
    end
        
    desc "import waterbodies"
    task :units_of_measure => :init do
      process File.join(ETL_ROOT, 'import', 'units_of_measure.ctl')
    end
    
    desc "import waterbodies"
    task :waterbodies => :init do
      process File.join(ETL_ROOT, 'import', 'waterbodies.ctl')
    end
  end
end

def initialize_etl_engine(options = {})
  require File.join(RAILS_ROOT, 'vendor', 'plugins', 'etl', 'lib', 'etl')
  require File.join(ETL_ROOT, 'lib', 'coordinate_import_processor')
  require File.join(ETL_ROOT, 'lib', 'nullify_processor')
  require File.join('active_record', 'connection_adapters', 'sqlserver_adapter') 
  require 'etl_engine_logger_mod'
  
  options = { :rails_root => RAILS_ROOT }.merge(options)
  ETL::Engine.init options
  ETL::Engine.realtime_activity = true
end

def process(files)
  puts "Starting ETL process"
  [files].flatten.each { |file| ETL::Engine.process file }
  puts "ETL process complete"  
end