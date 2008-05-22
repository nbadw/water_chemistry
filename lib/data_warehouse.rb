require 'text'
# includes functionality for the following:
#  export_to_warehouse
#  import_from_warehouse
#  commit_to_warehouse
#  intercept delete events and act accordingly
#  use commited_at column to signify inclusion/exclusion from warehouse
module DataWarehouse
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_incorporated(options = {})
      unless acts_as_incorporated? # don't let AR call this twice
        cattr_accessor :incorporated_attribute        
        self.incorporated_attribute = options[:with] || :incorporated_at
        include ActsAsMethods
      end
    end
    
    def acts_as_incorporated?
      self.included_modules.include?(ActsAsMethods)
    end
  end
  
  # These Acts As Methods are the methods added to the model class.  The methods directly under ActMethods are instance methods.
  module ActsAsMethods
    def self.included(base) 
      base.extend ClassMethods
    end
    
    def before_import      
    end

    def after_import      
    end

    def import_from_data_warehouse
      # check for explicit mapping of attribute to dw table column
      # otherwise attempt to guess the column name using the levenshtein distance
      # throw an error if all else fails
    end

    def before_export      
    end

    def after_export      
    end

    def export_to_data_warehouse      
      # check for explicit mapping of attribute to dw table column
      # otherwise attempt to guess the column name using the levenshtein distance
      # throw an error if all else fails
      self.incorporated_at = DateTime.now
    end
    
    def guess_target_attribute_column(target_attribute, possible_attributes)
      weighted_levenshtein_distances = possible_attributes.collect do |possible_attribute|
        word1 = target_attribute.gsub('_', '')
        word2 = possible_attribute.gsub('_', '')
        distance = Text::Levenshtein.distance(word1, word2)        
        { :attribute => possible_attribute, :weight => (word1.length - distance).abs.to_f / word1.length.to_f }
      end.sort { |a,b| a[:weight] <=> b[:weight] }
            
    end
    
    def incorporated?
      !!read_attribute(:incorporated_at)        
    end
    
    # These are class methods that are mixed in with the model class.
    module ClassMethods
      
    end
  end 
end
ActiveRecord::Base.send :include, DataWarehouse