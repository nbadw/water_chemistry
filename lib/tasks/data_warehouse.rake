ETL_ROOT = File.join(RAILS_ROOT, 'db', 'etl')

def define_import_tasks
  Dir[File.join(ETL_ROOT, 'scripts', 'control', 'import_*.ctl')].each do |import_file|
    import_file.match(/import_(.*)\.ctl/)
    name = $1
    desc "import #{name} table"
    task name => :etl_environment do
      puts 'processing import file ' + import_file
      ETL::Engine.process import_file 
    end
  end  
end

namespace :adw do
  task :etl_environment => :environment do
    require File.join(RAILS_ROOT, 'db', 'etl', 'init')
  end
  
  namespace :import do
    define_import_tasks
    
    desc "import all"
    task :all do
      Rake::Task['adw:etl_environment'].invoke
      Dir[File.join(ETL_ROOT, 'scripts', 'control', 'import_*.ctl')].each do |import_file|        
        puts 'processing import file ' + import_file
        ETL::Engine.process import_file 
      end  
    end    
  end
end

namespace :data_warehouse do 
  task :initialize_etl_engine => :environment do    
    initialize_etl_engine
  end 
    
  desc "run all import scripts"
  task :import do
    Rake::Task['data_warehouse:import:all'].invoke
  end
  
  desc "initial import"
  task :initial_import do
    Rake::Task['data_warehouse:initialize_etl_engine'].invoke
    imports = Dir[File.join(ETL_ROOT, 'initial_import', '*.ctl')]
    # declare task File.basename(files[0], '.ctl')
    imports.each { |script| process script }
  end
  
  namespace :import do 
    task :init do
      Rake::Task['data_warehouse:initialize_etl_engine'].invoke
    end
    
    task :all => [:agencies, :aquatic_activities, :aquatic_activity_events, :aquatic_activity_methods,
      :aquatic_site_usages, :aquatic_sites, :instruments, :observations, :observable_values,
      :measurements, :measurement_instrument, :measurement_unit, :units_of_measure, :waterbodies,
      :water_chemistry_parameters
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
    
    desc "import water chemistry parameters"
    task :water_chemistry_parameters => :init do
      process File.join(ETL_ROOT, 'import', 'water_chemistry_parameters.ctl')
    end
    
    desc "build text->id decode file for aquatic site coordinate systems"
    task :coordinate_system_text_to_id => :init do
      process File.join(ETL_ROOT, 'import', 'coordinate_system_text_to_id.ctl')
    end
    
    desc "build name->id decode file for coordinate sources"
    task :coordinate_source_to_id => :init do
      process File.join(ETL_ROOT, 'import', 'coordinate_source_to_id.ctl')
    end
    
    desc "import tblWaterBody"
    task :tblWaterBody => :init do
      process File.join(ETL_ROOT, 'initial_import', 'tblWaterBody.ctl')
    end
    
    desc "import tblDrainageUnit"
    task :tblDrainageUnit => :init do
      process File.join(ETL_ROOT, 'initial_import', 'tblDrainageUnit.ctl')
    end
  end
end

def initialize_etl_engine(options = {})
  require File.join(ETL_ROOT, 'lib', 'coordinate_import_processor')
  require File.join(ETL_ROOT, 'lib', 'ms_access')
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