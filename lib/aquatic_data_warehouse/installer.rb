# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module AquaticDataWarehouse
  class Installer
    def self.install
      AquaticDataWarehouse::Schema.up
    end
    
    def self.uninstall
      AquaticDataWarehouse::Schema.down
    end
  end
end
