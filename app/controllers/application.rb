# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add [:created_at, :updated_at, :lock_version]
    config.actions.add :config_list
    ActiveScaffold::Config::ConfigList.link.label = "Customize"
    config.actions.add :list_filter    
    config.actions.add :export
    config.export_force_quotes = true
  end
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => 'b4958123f303d2113b4dfa2351b9c245'
end
