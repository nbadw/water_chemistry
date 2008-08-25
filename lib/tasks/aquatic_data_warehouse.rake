namespace :adw do
  desc "install"
  task :install => :environment do
    AquaticDataWarehouse::Installer.install
  end
  
  desc "uninstall"
  task :uninstall => :environment do
    AquaticDataWarehouse::Installer.uninstall
  end
end
  