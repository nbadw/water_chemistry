module AquaticDataWarehouse  
  module Incorporated    
    class RecordIsIncorporated < ActiveRecord::ActiveRecordError
    end
    
    def self.included(base)
      base.before_destroy :check_if_incorporated
    end
    
    def authorized_for_destroy?
      !incorporated?
    end

    def authorized_for_update?
      !incorporated?
    end

    def incorporated?    
      if self.class.columns.detect { |column| column.name == 'IncorporatedInd' }
        !!incorporated_ind      
      end        
    end    

    private
    def check_if_incorporated
      raise(RecordIsIncorporated, "Incorporated records cannot be deleted") if incorporated?
    end
  end
end


