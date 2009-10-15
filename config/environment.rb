# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  config.frameworks -= [:active_resource]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "highline", :version => '1.5.1'
  config.gem "ruport", :version => '1.6.1'
  config.gem "ruport-util", :lib => "ruport/util", :version => '0.14.0'
  config.gem "GeoRuby", :lib => "geo_ruby", :version => '1.3.4'
  config.gem "action_mailer_tls", :lib => "smtp_tls.rb", :source => "http://gemcutter.org", :version => '1.1.3'
#  config.gem "newrelic_rpm"
  # for testing, the following gems should also be present
  # - mocha   (0.9.8)
  # - shoulda (2.10.2)
  # - hpricot (0.8.1)
  #   If using JRuby, clone http://github.com/olabini/hpricot or http://github.com/whymirror/hpricot/
  #   and then run the following commands to build hpricot:
  #     jruby -S rake package_jruby
  #     jruby -S gem install -l pkg/hpricot-0.8.1-jruby.gem
  if defined?(JRUBY_VERSION) # jruby-specific gems
    config.gem "activerecord-jdbc-adapter", :lib => 'jdbc_adapter'
    config.gem "torquebox-gem"
    config.gem "torquebox-rails"
  end

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  %w(aquatic_data_warehouse gis access_control).each do |dir|
    config.load_paths << "#{RAILS_ROOT}/app/models/#{dir}"
  end
  %w(observers sweepers mailers).each do |dir|
    config.load_paths << "#{RAILS_ROOT}/app/#{dir}"
  end

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
  
  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_nbadw_session',
    :secret      => 'f7ccddb583731efc258fafb8296fdbba8b75cc184856c3b43c351e85f1095aa3f957042e6d17bfcf62c94fc77fbb09fcac45eb0525ed4e369672a15fc46b047f'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  config.active_record.schema_format = :sql

  # Activate observers that should always be running
  config.active_record.observers = :user_observer
end