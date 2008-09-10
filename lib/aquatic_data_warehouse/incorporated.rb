module AquaticDataWarehouse  
  module Incorporated   
    def self.included(base)
      base.before_destroy :ensure_record_is_not_incorporated
      base.extend(ClassMethods)
    end
    
    module ClassMethods      
      def acts_as_incorporated?
        !columns.detect { |column| column.name == 'IncorporatedInd' }.nil?
      end
    end
    
    class RecordIsIncorporated < ActiveRecord::ActiveRecordError
    end  
    
    def authorized_for_destroy?
      !incorporated?
    end

    def authorized_for_update?
      !incorporated?
    end

    def incorporated?    
      !!incorporated_ind if self.class.acts_as_incorporated?        
    end       

    private
    def ensure_record_is_not_incorporated
      raise(RecordIsIncorporated, "Incorporated records cannot be deleted") if incorporated?
    end
  end
end


