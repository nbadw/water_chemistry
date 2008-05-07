set :application, "water_chemistry"
set :repository,  "http://svn2.assembla.com/svn/unb_dataentry/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "http://cri.nbwaters.unb.ca/"
role :web, "http://cri.nbwaters.unb.ca/"
role :db,  "http://cri.nbwaters.unb.ca/", :primary => true