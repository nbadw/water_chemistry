module DataWarehouse    
  module ActsAsIncorporated    
    class CannotBeIncorporatedError < ActiveRecord::ActiveRecordError;end        
    class RecordIsIncorporated < ActiveRecord::ActiveRecordError;end
    
    def self.included(base) 
      base.extend ClassMethods
    end
    
    module ClassMethods      
      def acts_as_incorporated(options = {})
        unless acts_as_importable? # don't let AR call this twice
          cattr_accessor :incorporated_column
          self.incorporated_column = options[:incorporated_column] || 'incorporatedind'
          
          # ensure the column is present and is a boolean type
          raise CannotBeIncorporatedError unless self.columns.find do |column|
            column.name == self.incorporated_column && column.type == :boolean
          end          
          
          alias_method :destroy_without_incorporated_check, :destroy          
          include IncorporatedMethods
        end
      end

      def acts_as_incorporated?
        self.included_modules.include?(IncorporatedMethods)
      end
    end
            
    # These IncorporatedMethods are the methods added to the model class.  The methods directly under IncorporatedMethods are instance methods.
    module IncorporatedMethods      
      def self.included(base) 
        base.extend ClassMethods
      end
      
      def incorporated?
        !!read_attribute(:incorporatedind)        
      end
      
      def destroy
        raise RecordIsIncorporated if incorporated?
        destroy_without_incorporated_check
      end

      # These are class methods that are mixed in with the model class.
      module ClassMethods   
      end
    end 
  end
end