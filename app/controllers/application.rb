# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include HoptoadNotifier::Catcher

  # Activescaffold content gets delivered through components, which are derived
  # from ApplicationController, so the components end up inheriting the following filters:
  before_filter :set_javascripts_and_stylesheets
  before_filter :set_locale
  # To prevent these filters from being performed twice, we can take advantage of the fact
  # that the request object is duplicated for the component rendering, so, when the filter
  # executes for the first time, we can store a flag indicating that it has already run, and
  # then skip the filter logic on any further passes.
  
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
    :navigation_tabs_partial, :included_stylesheets, :included_javascripts, :uses_gmap?
  
  def application_name
    :application_name.l
  end
  
  def page_title
    # TODO: figure out a way to translate controller names and actions
    @page_title || "#{:nbadw.l} - #{controller_name.titleize} - #{action_name.titleize}"
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
  
  def uses_gmap?
    false
  end
  
  protected    
  def include_stylesheet(stylesheet, options = {})
    included_stylesheets << [stylesheet, options]
  end
  
  def include_javascript(javascript, options = {})
    included_javascripts << [javascript, options]
  end

  def active_scaffold_session_cleanup
    backup = session.data.clone
    reset_session
    backup.each { |k, v| session[k] = v unless k.is_a?(String) && k =~ /^as:/ }
  end

  private
  def set_javascripts_and_stylesheets
    unless request.instance_variable_get(:@javascripts_and_stylesheets_set)
      request.instance_variable_set(:@javascripts_and_stylesheets_set, true)
      _set_javascripts_and_stylesheets
    end
  end

  def _set_javascripts_and_stylesheets
    include_stylesheet :base, { :merged => true }
    include_stylesheet :ie,   { :merged => true, :conditional => 'IE' }
    include_javascript :base, { :merged => true }
#    if Rails.env == 'development'
#      include_javascript 'http://getfirebug.com/releases/lite/1.2/firebug-lite-compressed.js', { :conditional => 'IE', :lazy_load => true }
#    end
  end

  def set_locale(&block)
    unless request.instance_variable_get(:@locale_set)
      request.instance_variable_set(:@locale_set, true)
      _set_locale(&block)
    end
  end

  # Set the locale from the parameters, the session, or the navigator
  # If none of these works, the Globalite default locale is set (en-*)
  def _set_locale
    # Try to get the locale from the parameters, from the session, and then from the navigator
    if params[:lang] && %w(en fr).include?(params[:lang])
      logger.debug "[globalite] using language passed as parameter: #{params[:lang]}"
      Locale.code = locale_code(params[:lang])
      # Store the locale in the session
      session[:locale] = Locale.code
    elsif logged_in?
      logger.debug "[globalite] using preferred language: #{current_user.language}"
      Locale.code = locale_code(current_user.language)
      # Store the locale in the session
      session[:locale] = Locale.code
    elsif session[:locale]
      logger.debug "[globalite] using locale from session: #{session[:locale]}"
      Locale.code = session[:locale]
    else
      logger.debug "[globalite] no locale information present - using default: #{Globalite.default_language}"
      Locale.code = locale_code(Globalite.default_language)
    end
    logger.debug "[globalite] Locale set to #{Locale.code}"
  end

  def locale_code(lang)
    "#{lang}-*"
  end
end
