module AquaticDataWarehouse  
  module Incorporated    
    class RecordIsIncorporated < ActiveRecord::ActiveRecordError
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def authorized_for_destroy?
        !incorporated?
      end

      def authorized_for_update?
        !incorporated?
      end

      def incorporated?    
        !!read_attribute(:exported_at)        
      end    

      private
      def check_if_incorporated
        raise(RecordIsIncorporated, "Incorporated records cannot be deleted") if incorporated?
      end
    end
  end
end


