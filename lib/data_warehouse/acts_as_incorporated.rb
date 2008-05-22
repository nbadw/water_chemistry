module DataWarehouse  
  # These IncorporatedMethods are the methods added to the model class.  The methods directly under IncorporatedMethods are instance methods.
  module IncorporatedMethods
    def self.included(base) 
      base.extend ClassMethods
    end
            
    def incorporated?
      !!read_attribute(:incorporated_at)        
    end
    
    # These are class methods that are mixed in with the model class.
    module ClassMethods; end
  end 
end