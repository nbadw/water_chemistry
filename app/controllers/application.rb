# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include HoptoadNotifier::Catcher
  
  before_filter :set_javascripts_and_stylesheets
  around_filter :set_locale
  
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
  
  def set_javascripts_and_stylesheets
    include_stylesheet :base, { :merged => true }
    include_stylesheet :ie,   { :merged => true, :conditional => 'IE' }
    include_javascript :base, { :merged => true }
    
    if Rails.env == 'development'
      include_javascript 'http://getfirebug.com/releases/lite/1.2/firebug-lite-compressed.js', { :conditional => 'IE', :lazy_load => true }
    end
  end

  private
  # Set the locale from the parameters, the session, or the navigator
  # If none of these works, the Globalite default locale is set (en-*)
  def set_locale
    # Get the current path and request method (useful in the layout for changing the language)
    @current_path = request.env['PATH_INFO']
    @request_method = request.env['REQUEST_METHOD']

    # Try to get the locale from the parameters, from the session, and then from the navigator
    if params[:user_locale]
      logger.debug "[globalite] #{params[:user_locale][:code]} locale passed"
      Locale.code = params[:user_locale][:code] #get_matching_ui_locale(params[:user_locale][:code]) #|| session[:locale] || get_valid_lang_from_accept_header || Globalite.default_language
      # Store the locale in the session
      session[:locale] = Locale.code
    elsif session[:locale]
      logger.debug "[globalite] loading locale: #{session[:locale]} from session"
      Locale.code = session[:locale]
    else
      header_lang = get_valid_lang_from_accept_header
      logger.debug "[globalite] found a valid http header locale: #{header_lang}"
      Locale.code = header_lang
    end

    logger.debug "[globalite] Locale set to #{Locale.code}"
    # render the page
    yield

    # reset the locale to its default value
    Locale.reset!
  end

  # Get a sorted array of the navigator languages
  def get_sorted_langs_from_accept_header
    accept_langs = (request.env['HTTP_ACCEPT_LANGUAGE'] || "en-us,en;q=0.5").split(/,/) rescue nil
    return nil unless accept_langs

    # Extract langs and sort by weight
    # Example HTTP_ACCEPT_LANGUAGE: "en-au,en-gb;q=0.8,en;q=0.5,ja;q=0.3"
    wl = {}
    accept_langs.each {|accept_lang|
      if (accept_lang + ';q=1') =~ /^(.+?);q=([^;]+).*/
        wl[($2.to_f rescue -1.0)]= $1
      end
    }
    logger.debug "[globalite] client accepted locales: #{wl.sort{|a,b| b[0] <=> a[0] }.map{|a| a[1] }.to_sentence}"
    sorted_langs = wl.sort{|a,b| b[0] <=> a[0] }.map{|a| a[1] }
  end

  # Returns a valid language that best suits the HTTP_ACCEPT_LANGUAGE request header.
  # If no valid language can be deduced, then <tt>nil</tt> is returned.
  def get_valid_lang_from_accept_header
    # Get the sorted navigator languages and find the first one that matches our available languages
    get_sorted_langs_from_accept_header.detect{|l| get_matching_ui_locale(l) }
  end

  # Returns the UI locale that best matches with the parameter
  # or nil if not found
  def get_matching_ui_locale(locale)
    lang = locale[0,2].downcase
    if locale[3,5]
      country = locale[3,5].upcase
      logger.debug "[globalite] trying to match locale: #{lang}-#{country}"
      locale_code = "#{lang}-#{country}".to_sym
    else
      logger.debug "[globalite] trying to match #{lang}-*"
      locale_code = "#{lang}-*".to_sym
    end

    # Check with exact matching
    if Globalite.ui_locales.values.include?(locale)
      logger.debug "[globalite] Globalite does include #{locale}"
      locale_code
    end

    # Check on the language only
    Globalite.ui_locales.values.each do |value|
      value.to_s =~ /#{lang}-*/ ? value : nil
    end
  end
end
