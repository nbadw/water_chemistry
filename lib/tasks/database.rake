namespace :db do
  desc "Migrate schema to version 0 and back up again. WARNING: Destroys all data in tables!!"
  task :remigrate => :environment do
    require 'highline/import'
    if ENV['OVERWRITE'].to_s.downcase == 'true' or agree("This task will destroy any data in the database. Are you sure you want to \ncontinue? [yn] ")      
      # Migrate downward
      ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate/", 0)
    
      # Migrate upward 
      Rake::Task["db:migrate"].invoke
      
      # Dump the schema
      if ActiveRecord::Base.schema_format == :ruby
        Rake::Task["db:schema:dump"].invoke
      else
        Rake::Task["db:structure:dump"].invoke
      end
    else
      say "Task cancelled."
      exit
    end
  end
  
  desc "Bootstrap your database."
  task :bootstrap => :remigrate do
    require 'aquatic_data_warehouse/setup'
    AquaticDataWarehouse::Setup.bootstrap(
      :admin_name => ENV['ADMIN_NAME'],
      :admin_username => ENV['ADMIN_USERNAME'],
      :admin_password => ENV['ADMIN_PASSWORD'],
      :admin_email => ENV['ADMIN_EMAIL'],
      :admin_agency => ENV['ADMIN_AGENCY']
    )
  end
end