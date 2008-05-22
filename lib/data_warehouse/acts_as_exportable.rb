module DataWarehouse
  # These ExportMethods are the methods added to the model class.  The methods directly under ExportMethods are instance methods.
  module ExportMethods
    def self.included(base) 
      base.extend ClassMethods
    end
    
    def before_export      
    end

    def after_export      
    end

    def export_to_data_warehouse      
      # check for explicit mapping of attribute to dw table column
      # otherwise attempt to guess the column name using the levenshtein distance
      # throw an error if all else fails
    end
    
    # These are class methods that are mixed in with the model class.
    module ClassMethods; end
  end
end