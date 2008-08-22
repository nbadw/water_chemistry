class DataCollectionSite < ActiveRecord::Base 
  include ActiveRecord::BaseProxy
  
  map :id, :class => 'TblAquaticSite', :column => 'aquaticsiteid'
  map :name, :class => 'TblAquaticSite', :column => 'aquaticsitename'
  map :description, :class => 'TblAquaticSite', :column => 'aquaticsitedesc'
  map :incorporated, :class => 'TblAquaticSite', :column => 'incorporatedind'
  map :waterbody_id, :class => 'TblWaterbody', :column => 'waterbodyid'
  map :waterbody_name, :class => 'TblWaterbody', :column => 'waterbodyname'
  map :drainage_code, :class => 'TblWaterbody', :column => 'drainagecd'
  
   # [:incorporated, :id, :name, :description, :agencies, :waterbody_id, :waterbody_name, :drainage_code, :name_and_description, :aquatic_activities] 

  class << self    
    def count(*args)
      options = args.extract_options!
      options[:order] = nil
      TblAquaticSite.count(options)    
    end
  
    def find(*args)
      options = map_options(args.extract_options!)
      
      # preload the waterbody always
      options[:include] = (options[:include] || []) << [:waterbody]      
      
      results = TblAquaticSite.find(args.first, options)
      records = []
      if results
        [results].flatten.each do |result|
          data_collection_site = self.new
          data_collection_site.tbl_aquatic_site = result
          data_collection_site.tbl_waterbody = result.waterbody
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
    
    def map_options(options)
      return nil unless options
      
      mapped_options = {}
      options.each do |option, value|
        rename_func = lambda { |str|
          str.match(/#{self.table_name}.`([^`]*)/)
          column = $1          
          mapping = mappings[column]          
          str.gsub(/#{self.table_name}.`#{column}`/, "#{mapping[:class].constantize.table_name}.`#{mapping[:column]}`")
        }
        
        if value.is_a?(String)
          new_value = rename_func.call value
        elsif new_value.is_a?(Array)
          new_value = value
        else
          new_value = value
        end
        mapped_options[option] = new_value
      end
      
      mapped_options
    end
  end 
end
