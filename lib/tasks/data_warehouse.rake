# this rule acts like ruby's method missing for rake tasks
# see http://nubyonrails.com/articles/2006/07/28/foscon-and-living-dangerously-with-rake
rule "" do |t|
  # data_warehouse:import:method
  if /^data_warehouse:import:(.*)/.match(t.name)
    import t.name.split(":").last    
  elsif /^data_warehouse:export:(.*)/.match(t.name)
    puts t.name.split(":")[1..-1].last
  end
end

namespace :data_warehouse do     
  desc "import all"
  task :import do
    import :all
  end    
  
  desc "export all"
  task :export => :environment do 
    
  end
end

def import(model_name)
  Rake::Task[:environment].invoke
  # this makes sure that ActiveRecord::Base.subclass reports the correct files
  Dir.glob(File.join(RAILS_ROOT,'app','models','**','*.rb')).each do |file|
    require_dependency file
  end
  if model_name == :all
    imports = ActiveRecord::Base.send(:subclasses).select { |klass| klass.acts_as_importable? }
  else
    imports = [model_name.classify.constantize]
  end  
  
  imports.each do |klass|
    puts "importing data warehouse records into #{klass.table_name} table"
    klass.import_from_data_warehouse
  end
end