set :application, "water_chemistry"
set :repository,  "http://svn.assembla.com/svn/adw_data_entry/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www"
set :user, 'colin'

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm_username, 'ccasey'

server "adw-staging", :app, :web, :db, :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end