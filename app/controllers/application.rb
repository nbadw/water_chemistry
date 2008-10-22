# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  before_filter :set_javascripts_and_stylesheets
  
  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add [:created_at, :updated_at, :created_by, :updated_by, :lock_version]
  end

  # TODO: enable forgery protection and parameter filtering  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store  
  #protect_from_forgery # :secret => 'b4958123f303d2113b4dfa2351b9c245'  
  #filter_parameter_logging :password, :password_confirmation
  
  # helpers to include additional assets from actions or views
  helper_method :include_stylesheet, :include_javascript
  
  def include_stylesheet(sheet)
    @stylesheets << sheet
  end
  
  def include_javascript(script)
    @javascripts << script
  end
  
  private    
  def set_javascripts_and_stylesheets
    @stylesheets = '' # %w(admin/main)
    @javascripts = '' # %w(prototype string effects admin/tabcontrol admin/ruledtable admin/admin)
  end
end
