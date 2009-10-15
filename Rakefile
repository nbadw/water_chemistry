# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'
if defined?(JRUBY_VERSION)
  ENV['JBOSS_HOME'] = ENV['JBOSS_HOME'] || '/home/colin/servers/torquebox-current/jboss'
  require 'torquebox/tasks'  # deployment tasks
  require 'tasks/jdbc_tasks' # jdbc-specific database tasks

  desc "Deploy the Rails app"
  task :deploy, :needs =>['torquebox:server:check'] do |t|
    Rake::Task['torquebox:rails:deploy'].invoke('/')
  end
end