set :application, "water_chemistry"
set :user,         "colin"
set :use_sudo,     false
set :deploy_to,    "/var/www/apps/#{application}"

set :scm,          :subversion
set :repository,  "http://svn.assembla.com/svn/adw_data_entry/trunk"

server "cri-linux.nbwaters.unb.ca", :app, :web, :db, :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :after_symlink do
    build_packaged_assets
  end

  desc "Build Packaged Assets"
  task :build_packaged_assets, :roles => :app do
    run("cd #{deploy_to}/current; rake asset:packager:build_all")
  end
end