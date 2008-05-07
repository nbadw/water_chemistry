namespace :bootstrap do 
  desc "bootstrap aquatic sites"
  task :aquatic_sites => :environment do
    export_to :model => :aquatic_sites,
      :records => import_from(:table => 'tblAquaticSite', :primary_key => 'AquaticSiteID')
  end
  
  desc "bootstrap watersheds"
  task :watersheds => :environment do    
    export_to :model => :watershed, 
      :records => import_from(:table => 'tblDrainageUnit', :primary_key => 'DrainageCd')
  end

  desc "bootstrap waterbodies"
  task :waterbodies => :environment do
    export_to :model => :waterbody,
      :records => import_from(:table => 'tblWaterBody', :primary_key => 'WaterBodyID')
  end
end

def export_to(options = {})
  records = options[:records]
  model = options[:model].to_s
  records.each_with_index do |record, i|
    puts "importing #{model} record #{i+1} of #{records.size}"
    begin
      model.classify.constantize.send(:import_from_datawarehouse, record) 
    rescue
      puts "IMPORT ERROR: #{exc.message} - #{record.inspect}"
    end
  end
end

def import_from(options = {})
  puts 'connecting to datawarehouse'
  # create an active record connection to the sqlserver database
  ActiveRecord::Base.establish_connection(YAML::load_file("#{RAILS_ROOT}/config/bootstrap.yml"))    
  require "#{RAILS_ROOT}/lib/sqlserver_adapter"  
     
  dw_table = Class.new(ActiveRecord::Base) do
    set_table_name  options[:table].downcase
    set_primary_key options[:primary_key].downcase if options.has_key?(:primary_key)
  end  
  
  puts "reading data from #{options[:table]}"
  records = dw_table.find :all
   
  # restore active record connection
  ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])   
  
  puts "#{records.size} records ready for import"   
  records.collect { |record| record.attributes }
end