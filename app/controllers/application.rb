# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include HoptoadNotifier::Catcher
  
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
  helper_method :application_name, :page_title, :current_location, :previous_location,
    :navigation_tabs_partial, :included_stylesheets, :included_javascripts
  
  def application_name
    'NB Aquatic Data Warehouse Data Management Application'
  end
  
  def page_title
    "NB Aquatic Data Warehouse - #{controller_name.titleize} - #{action_name.titleize}"
  end
  
  def current_location
    page_title
  end
  
  def previous_location
    nil
  end
  
  def navigation_tabs_partial  
    'navigation_tabs'
  end
  
  def included_stylesheets
    @stylesheets ||= []
  end
  
  def included_javascripts
    @javascripts ||= []
  end
  
  protected    
  def include_stylesheet(stylesheet, options = {})
    included_stylesheets << [stylesheet, options]
  end
  
  def include_javascript(javascript, options = {})
    included_javascripts << [javascript, options]
  end  
  
  def include_gmap_javascript(options = {})
    gmap = "http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{ApiKey.get}"
    include_javascript(gmap, options)
  end
  
  def set_javascripts_and_stylesheets
    include_stylesheet :base, { :merged => true }
    include_stylesheet :ie,   { :merged => true, :conditional => 'IE' }
    include_javascript :base, { :merged => true }
    
    if Rails.env == 'development'
      include_javascript 'http://getfirebug.com/releases/lite/1.2/firebug-lite-compressed.js', { :conditional => 'IE', :lazy_load => true }
    end
  end
end
