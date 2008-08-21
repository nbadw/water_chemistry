class DataCollectionSite < ActiveRecord::Base 
  include ActiveRecord::BaseProxy
  
  map :id, :class => 'TblAquaticSite', :column => 'aquaticsiteid'
  map :name, :class => 'TblAquaticSite', :column => 'aquaticsitename'
  map :description, :class => 'TblAquaticSite', :column => 'aquaticsitedesc'
  map :incorporated, :class => 'TblAquaticSite', :column => 'incorporatedind'
   # [:incorporated, :id, :name, :description, :agencies, :waterbody_id, :waterbody_name, :drainage_code, :name_and_description, :aquatic_activities] 

  class << self    
    def count(*args)
      options = args.extract_options!
      options[:order] = nil
      TblAquaticSite.count(options)    
    end
  
    def find(*args)
      options = args.extract_options!
      options[:order] = nil
      results = TblAquaticSite.find(args.first, options)
      records = []
      if results
        [results].flatten.each do |result|
          record = self.new
          record.tbl_aquatic_site = result
          records << record
        end
      end    
    
      case args.first
      when :first then records[0]
      when :last  then records[0]
      when :all   then records
      else             records[0]
      end
    end      
  end 
end
