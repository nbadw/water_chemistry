# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module AquaticDataWarehouse
  class Installer
    def self.install
      if Schema.installed?
        raise "Aquatic Data Warehouse is already installed"     
      end
      
      puts "installing aquatic data warehouse database"
      Schema.install
      puts "install complete"
    end
    
    def self.uninstall
      unless Schema.installed?
        raise "Aquatic Data Warehouse has not been installed" 
      end
      
      puts "uninstalling aquatic data warehouse database"
      Schema.uninstall
      puts "uninstall complete"
    end
  end
end
