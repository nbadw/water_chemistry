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
end