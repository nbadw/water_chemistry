# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module AquaticDataWarehouse
  class BaseTbl < AquaticDataWarehouse::Base
    self.abstract_class = true        
    
    def self.adw_prefix
      'tbl'
    end
  end
end
